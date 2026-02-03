import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/health_unit_profile.dart';

class HealthUnitProfileRepository {
  HealthUnitProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<HealthUnitProfile?> watchProfile(String uid) {
    return _firestore.collection('healthUnitProfiles').doc(uid).snapshots().map(
          (doc) => doc.exists ? HealthUnitProfile.fromFirestore(doc) : null,
        );
  }

  Future<void> upsertProfile(HealthUnitProfile profile) async {
    await _firestore
        .collection('healthUnitProfiles')
        .doc(profile.uid)
        .set(profile.toFirestore(), SetOptions(merge: true));
  }
}
