import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_job.dart';
import '../models/shared_types.dart';
import '../repositories/worker_job_feed_repository.dart';

/// Firestore implementation of WorkerJobFeedRepository.
/// Reads job posts from the 'jobs' collection for workers.
class FirestoreWorkerJobFeedRepository implements WorkerJobFeedRepository {
  final FirebaseFirestore _firestore;
  final String _currentWorkerId;

  FirestoreWorkerJobFeedRepository({
    FirebaseFirestore? firestore,
    required String currentWorkerId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _currentWorkerId = currentWorkerId;

  CollectionReference<Map<String, dynamic>> get _jobsCollection =>
      _firestore.collection('jobs');

  @override
  Future<List<WorkerJobSummary>> getRecommendedJobs() async {
    // Get all open jobs that are not assigned to any worker yet
    final snapshot = await _jobsCollection
        .where('status', isEqualTo: JobPostStatus.open.name)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => WorkerJobSummary.fromMap(
              doc.data(),
              doc.id,
              workerId: _currentWorkerId,
            ))
        .toList();
  }

  @override
  Future<List<WorkerJobSummary>> getInvitedJobs() async {
    // Get jobs where this worker was explicitly invited
    final snapshot = await _jobsCollection
        .where('invitedProIds', arrayContains: _currentWorkerId)
        .where('status', isEqualTo: JobPostStatus.open.name)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WorkerJobSummary.fromMap(
              doc.data(),
              doc.id,
              workerId: _currentWorkerId,
            ))
        .toList();
  }

  @override
  Future<WorkerJobDetail> getJobDetail(String jobId) async {
    final doc = await _jobsCollection.doc(jobId).get();
    if (!doc.exists || doc.data() == null) {
      throw StateError('Job $jobId not found');
    }

    return WorkerJobDetail.fromMap(
      doc.data()!,
      doc.id,
      workerId: _currentWorkerId,
    );
  }
}
