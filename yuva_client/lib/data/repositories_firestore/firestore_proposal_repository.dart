import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_models.dart';
import '../repositories/proposal_repository.dart';

/// Firestore implementation of ProposalRepository for client app.
/// Reads proposals from the jobs/{jobId}/proposals subcollection.
class FirestoreProposalRepository implements ProposalRepository {
  final FirebaseFirestore _firestore;
  // ignore: unused_field - Reserved for future authorization checks
  final String _currentUserId;

  FirestoreProposalRepository({
    FirebaseFirestore? firestore,
    required String currentUserId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentUserId = currentUserId;

  CollectionReference<Map<String, dynamic>> _proposalsCollection(String jobId) =>
      _firestore.collection('jobs').doc(jobId).collection('proposals');

  /// Active statuses that should be visible to clients
  static const _activeStatuses = ['submitted', 'shortlisted', 'hired'];

  @override
  Future<List<Proposal>> getProposalsForJob(String jobPostId) async {
    final snapshot = await _proposalsCollection(jobPostId)
        .where('status', whereIn: _activeStatuses)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Proposal.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<Proposal> submitProposal(Proposal proposal) async {
    // This is typically called by workers, but we implement it for completeness
    final docRef = await _proposalsCollection(proposal.jobPostId).add({
      ...proposal.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return proposal.copyWith(id: docRef.id);
  }

  @override
  Future<Proposal> updateProposalStatus({
    required String jobPostId,
    required String proposalId,
    required ProposalStatus status,
  }) async {
    // Get the proposal document directly using the jobPostId
    final doc = await _proposalsCollection(jobPostId).doc(proposalId).get();

    if (!doc.exists || doc.data() == null) {
      throw StateError('Proposal $proposalId not found');
    }

    final data = doc.data()!;
    final currentStatus = data['status'] as String? ?? 'submitted';
    
    // Validate status transition
    if (!_canTransitionTo(currentStatus, status.name)) {
      throw StateError('Cannot change proposal status from $currentStatus to ${status.name}');
    }

    await _proposalsCollection(jobPostId).doc(proposalId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // TODO: Trigger Cloud Function to send notification to worker:
    // - Shortlisted: notification type 'proposal_shortlisted'
    // - Rejected: notification type 'proposal_rejected'

    final proposal = Proposal.fromMap(data, doc.id);
    return proposal.copyWith(status: status);
  }
  
  /// Validates if a status transition is allowed
  bool _canTransitionTo(String currentStatus, String newStatus) {
    // Terminal states - no transitions allowed
    if (currentStatus == 'hired' || currentStatus == 'withdrawn') {
      return false;
    }
    
    // From rejected, only allow if going back to shortlisted (undo reject)
    if (currentStatus == 'rejected') {
      return newStatus == 'shortlisted';
    }
    
    // From submitted, can go to shortlisted, rejected, or hired
    if (currentStatus == 'submitted') {
      return ['shortlisted', 'rejected', 'hired'].contains(newStatus);
    }
    
    // From shortlisted, can go to rejected or hired
    if (currentStatus == 'shortlisted') {
      return ['rejected', 'hired'].contains(newStatus);
    }
    
    return false;
  }

  /// Stream of proposals for a job (for real-time updates).
  /// Only returns active proposals (excludes withdrawn/rejected).
  Stream<List<Proposal>> watchProposalsForJob(String jobPostId) {
    return _proposalsCollection(jobPostId)
        .where('status', whereIn: _activeStatuses)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Proposal.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Returns the count of active proposals for a job.
  Future<int> getActiveProposalCount(String jobPostId) async {
    final snapshot = await _proposalsCollection(jobPostId)
        .where('status', whereIn: _activeStatuses)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
