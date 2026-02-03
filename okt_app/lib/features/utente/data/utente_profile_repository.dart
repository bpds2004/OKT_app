import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/utente_profile.dart';

class UtenteProfileRepository {
  UtenteProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<UtenteProfile?> watchProfile(String uid) {
    return _firestore.collection('utenteProfiles').doc(uid).snapshots().map(
          (doc) => doc.exists ? UtenteProfile.fromFirestore(doc) : null,
        );
  }

  Future<void> upsertProfile(UtenteProfile profile) async {
    await _firestore
        .collection('utenteProfiles')
        .doc(profile.uid)
        .set(profile.toFirestore(), SetOptions(merge: true));
  }
}
