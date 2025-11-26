import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_models.dart';
import '../repositories/job_post_repository.dart';

/// Firestore implementation of JobPostRepository for client app.
/// Reads and writes job posts to the 'jobs' collection.
class FirestoreJobPostRepository implements JobPostRepository {
  final FirebaseFirestore _firestore;
  final String _currentUserId;

  FirestoreJobPostRepository({
    FirebaseFirestore? firestore,
    required String currentUserId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentUserId = currentUserId;

  CollectionReference<Map<String, dynamic>> get _jobsCollection =>
      _firestore.collection('jobs');

  @override
  Future<List<JobPost>> getJobPostsForClient(String userId) async {
    final snapshot = await _jobsCollection
        .where('clientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => JobPost.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<JobPost?> getJobPostById(String id) async {
    final doc = await _jobsCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return JobPost.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<JobPost> createJobPost(JobPost post) async {
    final now = DateTime.now();
    final jobToCreate = post.copyWith(
      userId: _currentUserId,
      createdAt: now,
      updatedAt: now,
      status: JobPostStatus.open,
    );

    final docRef = await _jobsCollection.add({
      ...jobToCreate.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return jobToCreate.copyWith(id: docRef.id);
  }

  @override
  Future<JobPost> updateJobPost(JobPost post) async {
    // Verify the job exists and is modifiable
    final doc = await _jobsCollection.doc(post.id).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError('Job ${post.id} not found');
    }
    
    final currentJob = JobPost.fromMap(doc.data()!, doc.id);
    
    // Verify ownership
    if (currentJob.userId != _currentUserId) {
      throw const JobNotModifiableException('You do not own this job.');
    }
    
    // Verify job is still modifiable
    if (!currentJob.canClientModify) {
      throw const JobNotModifiableException('This job can no longer be edited.');
    }
    
    final now = DateTime.now();
    final updatedPost = post.copyWith(updatedAt: now);

    // Only update modifiable fields, preserve system fields
    await _jobsCollection.doc(post.id).update({
      'titleKey': updatedPost.titleKey,
      'descriptionKey': updatedPost.descriptionKey,
      'customTitle': updatedPost.customTitle,
      'customDescription': updatedPost.customDescription,
      'serviceTypeId': updatedPost.serviceTypeId,
      'propertyType': updatedPost.propertyDetails.type.name,
      'sizeCategory': updatedPost.propertyDetails.sizeCategory.name,
      'bedrooms': updatedPost.propertyDetails.bedrooms,
      'bathrooms': updatedPost.propertyDetails.bathrooms,
      'budgetType': updatedPost.budgetType.name,
      'hourlyRateFrom': updatedPost.hourlyRateFrom,
      'hourlyRateTo': updatedPost.hourlyRateTo,
      'fixedBudget': updatedPost.fixedBudget,
      'areaLabel': updatedPost.areaLabel,
      'frequency': updatedPost.frequency.name,
      'preferredStartDate': updatedPost.preferredStartDate,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return updatedPost;
  }

  @override
  Future<void> deleteJob(String jobId) async {
    final doc = await _jobsCollection.doc(jobId).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError('Job $jobId not found');
    }
    
    final job = JobPost.fromMap(doc.data()!, doc.id);
    
    // Verify ownership
    if (job.userId != _currentUserId) {
      throw const JobNotModifiableException('You do not own this job.');
    }
    
    // Verify job is still modifiable
    if (!job.canClientModify) {
      throw const JobNotModifiableException('This job can no longer be deleted.');
    }
    
    // Mark as cancelled instead of hard delete to preserve history
    await _jobsCollection.doc(jobId).update({
      'status': JobPostStatus.cancelled.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<JobPost> invitePro({
    required String jobPostId,
    required String proId,
  }) async {
    final doc = await _jobsCollection.doc(jobPostId).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError('Job $jobPostId not found');
    }

    final job = JobPost.fromMap(doc.data()!, doc.id);
    if (job.invitedProIds.contains(proId)) {
      return job;
    }

    final updatedInvitedProIds = [...job.invitedProIds, proId];
    await _jobsCollection.doc(jobPostId).update({
      'invitedProIds': updatedInvitedProIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return job.copyWith(
      invitedProIds: updatedInvitedProIds,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<JobPost> hireProposal({
    required String jobPostId,
    required String proposalId,
    required String proId,
  }) async {
    final doc = await _jobsCollection.doc(jobPostId).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError('Job $jobPostId not found');
    }

    await _jobsCollection.doc(jobPostId).update({
      'status': JobPostStatus.hired.name,
      'hiredProposalId': proposalId,
      'hiredProId': proId,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final job = JobPost.fromMap(doc.data()!, doc.id);
    return job.copyWith(
      status: JobPostStatus.hired,
      hiredProposalId: proposalId,
      hiredProId: proId,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<JobPost> updateStatus({
    required String jobPostId,
    required JobPostStatus status,
  }) async {
    final doc = await _jobsCollection.doc(jobPostId).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError('Job $jobPostId not found');
    }

    await _jobsCollection.doc(jobPostId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final job = JobPost.fromMap(doc.data()!, doc.id);
    return job.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
  }
}
