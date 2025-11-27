import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_models.dart';
import '../repositories/pro_summary_repository.dart';

/// Firestore implementation of ProSummaryRepository.
/// Reads worker profiles from the 'workers' collection.
class FirestoreProSummaryRepository implements ProSummaryRepository {
  final FirebaseFirestore _firestore;

  FirestoreProSummaryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _workersCollection =>
      _firestore.collection('workers');

  @override
  Future<List<ProSummary>> getPros() async {
    // Get all workers - we'll filter out incomplete profiles client-side if needed
    // This is more flexible as workers might not have isProfileComplete field set
    final snapshot = await _workersCollection
        .limit(50)
        .get();

    return snapshot.docs
        .where((doc) {
          final data = doc.data();
          // Filter out workers without a display name
          final name = data['displayName'] as String? ?? data['name'] as String?;
          return name != null && name.isNotEmpty;
        })
        .map((doc) => _proSummaryFromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<ProSummary?> getProById(String id) async {
    if (id.isEmpty) return null;
    
    final doc = await _workersCollection.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    
    return _proSummaryFromMap(doc.data()!, doc.id);
  }

  @override
  Future<List<ProSummary>> getProsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    
    // Firestore 'whereIn' is limited to 10 items, so we batch
    final results = <ProSummary>[];
    for (var i = 0; i < ids.length; i += 10) {
      final batch = ids.skip(i).take(10).toList();
      final snapshot = await _workersCollection
          .where(FieldPath.documentId, whereIn: batch)
          .get();
      
      results.addAll(
        snapshot.docs.map((doc) => _proSummaryFromMap(doc.data(), doc.id)),
      );
    }
    return results;
  }

  ProSummary _proSummaryFromMap(Map<String, dynamic> map, String docId) {
    final displayName = map['displayName'] as String? ?? 
                        map['name'] as String? ?? 
                        'Profesional';
    
    // Generate initials from display name
    final initials = displayName.isNotEmpty
        ? displayName
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .take(2)
            .join()
            .toUpperCase()
        : null;

    return ProSummary(
      id: docId,
      displayName: displayName,
      ratingAverage: (map['rating'] as num?)?.toDouble() ?? 
                     (map['ratingAverage'] as num?)?.toDouble() ?? 
                     5.0,
      ratingCount: map['ratingCount'] as int? ?? 
                   map['reviewCount'] as int? ?? 
                   0,
      areaLabel: map['areaLabel'] as String? ?? 
                 map['zone'] as String? ?? 
                 map['location'] as String? ?? 
                 '',
      offeredServiceTypeIds: List<String>.from(
        map['offeredServiceTypeIds'] ?? 
        map['serviceTypes'] ?? 
        map['services'] ?? 
        ['standard'],
      ),
      avatarInitials: initials,
    );
  }
}
