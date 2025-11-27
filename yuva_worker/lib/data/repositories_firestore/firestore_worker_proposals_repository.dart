import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_proposal.dart';
import '../models/shared_types.dart';
import '../repositories/worker_proposals_repository.dart';

/// Firestore implementation of WorkerProposalsRepository.
/// Stores proposals as subcollections under jobs: jobs/{jobId}/proposals/{proposalId}
class FirestoreWorkerProposalsRepository implements WorkerProposalsRepository {
  final FirebaseFirestore _firestore;
  final String _currentWorkerId;
  final String? _workerDisplayName;
  final String? _workerAvatarInitials;
  final String? _workerPhotoUrl;
  final String? _workerAvatarId;

  FirestoreWorkerProposalsRepository({
    FirebaseFirestore? firestore,
    required String currentWorkerId,
    String? workerDisplayName,
    String? workerAvatarInitials,
    String? workerPhotoUrl,
    String? workerAvatarId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentWorkerId = currentWorkerId,
        _workerDisplayName = workerDisplayName,
        _workerAvatarInitials = workerAvatarInitials,
        _workerPhotoUrl = workerPhotoUrl,
        _workerAvatarId = workerAvatarId;

  CollectionReference<Map<String, dynamic>> _proposalsCollection(String jobId) =>
      _firestore.collection('jobs').doc(jobId).collection('proposals');

  @override
  Future<List<WorkerProposal>> getMyProposals({
    WorkerProposalFilter? filter,
  }) async {
    // Query all jobs and get proposals where workerId matches current worker
    // This is a collectionGroup query across all proposals subcollections
    Query<Map<String, dynamic>> query = _firestore
        .collectionGroup('proposals')
        .where('workerId', isEqualTo: _currentWorkerId);

    if (filter?.statuses != null && filter!.statuses!.isNotEmpty) {
      query = query.where(
        'status',
        whereIn: filter.statuses!.map((s) => s.name).toList(),
      );
    }

    if (filter?.jobPostId != null) {
      query = query.where('jobId', isEqualTo: filter!.jobPostId);
    }

    final snapshot = await query.orderBy('createdAt', descending: true).get();

    return snapshot.docs
        .map((doc) => WorkerProposal.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<WorkerProposal?> getProposalForJob(String jobPostId) async {
    final snapshot = await _proposalsCollection(jobPostId)
        .where('workerId', isEqualTo: _currentWorkerId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return WorkerProposal.fromMap(
      snapshot.docs.first.data(),
      snapshot.docs.first.id,
    );
  }

  @override
  Future<WorkerProposal> createDraftProposal(String jobPostId) async {
    final now = DateTime.now();
    final proposal = WorkerProposal(
      id: '', // Will be set by Firestore
      jobPostId: jobPostId,
      workerId: _currentWorkerId,
      budgetType: JobBudgetType.hourly,
      coverLetterKey: '',
      status: WorkerProposalStatus.draft,
      createdAt: now,
    );

    final docRef = await _proposalsCollection(jobPostId).add({
      ...proposal.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return proposal.copyWith(id: docRef.id);
  }

  @override
  Future<WorkerProposal> updateProposal(WorkerProposal proposal) async {
    await _proposalsCollection(proposal.jobPostId).doc(proposal.id).update({
      'proposedHourlyRate': proposal.proposedHourlyRate,
      'proposedFixedPrice': proposal.proposedFixedPrice,
      'budgetType': proposal.budgetType.name,
      'estimatedHours': proposal.estimatedHours,
      'message': proposal.coverLetterKey,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return proposal.copyWith(lastUpdatedAt: DateTime.now());
  }

  @override
  Future<WorkerProposal> submitProposal(String proposalId) async {
    // First, we need to find the proposal to get its jobPostId
    final allProposals = await getMyProposals();
    final proposal = allProposals.firstWhere(
      (p) => p.id == proposalId,
      orElse: () => throw StateError('Proposal $proposalId not found'),
    );

    await _proposalsCollection(proposal.jobPostId).doc(proposalId).update({
      'status': WorkerProposalStatus.submitted.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return proposal.copyWith(
      status: WorkerProposalStatus.submitted,
      lastUpdatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteDraft(String proposalId) async {
    // Find the proposal first to get its jobPostId
    final allProposals = await getMyProposals(
      filter: const WorkerProposalFilter(
        statuses: [WorkerProposalStatus.draft],
      ),
    );
    
    final proposal = allProposals.firstWhere(
      (p) => p.id == proposalId,
      orElse: () => throw StateError('Draft proposal $proposalId not found'),
    );

    await _proposalsCollection(proposal.jobPostId).doc(proposalId).delete();
  }

  @override
  Future<void> withdrawProposal(String proposalId, String jobPostId) async {
    await _proposalsCollection(jobPostId).doc(proposalId).update({
      'status': WorkerProposalStatus.withdrawn.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Creates and submits a proposal in one step (convenience method).
  Future<WorkerProposal> createAndSubmitProposal({
    required String jobPostId,
    required JobBudgetType budgetType,
    double? proposedHourlyRate,
    double? proposedFixedPrice,
    int? estimatedHours,
    required String message,
  }) async {
    final now = DateTime.now();
    final proposal = WorkerProposal(
      id: '',
      jobPostId: jobPostId,
      workerId: _currentWorkerId,
      proposedHourlyRate: proposedHourlyRate,
      proposedFixedPrice: proposedFixedPrice,
      budgetType: budgetType,
      estimatedHours: estimatedHours,
      coverLetterKey: message,
      status: WorkerProposalStatus.submitted,
      createdAt: now,
    );

    final docRef = await _proposalsCollection(jobPostId).add({
      ...proposal.toMap(),
      'status': WorkerProposalStatus.submitted.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      // Denormalized worker info for client display
      'workerDisplayName': _workerDisplayName,
      'workerAvatarInitials': _workerAvatarInitials,
      'workerPhotoUrl': _workerPhotoUrl,
      'workerAvatarId': _workerAvatarId,
    });

    return proposal.copyWith(id: docRef.id);
  }

  /// Updates an existing proposal's fields.
  Future<void> updateProposalFields({
    required String jobPostId,
    required String proposalId,
    required JobBudgetType budgetType,
    double? proposedHourlyRate,
    double? proposedFixedPrice,
    int? estimatedHours,
    required String message,
  }) async {
    final data = <String, dynamic>{
      'budgetType': budgetType.name,
      'proposedHourlyRate': proposedHourlyRate,
      'proposedFixedPrice': proposedFixedPrice,
      'estimatedHours': estimatedHours,
      'message': message,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _proposalsCollection(jobPostId).doc(proposalId).update(data);
  }
}
