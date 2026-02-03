import 'package:cloud_firestore/cloud_firestore.dart';

class UtenteProfile {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String numeroUtente;
  final String nif;
  final String birthDate;
  final String medicalHistory;
  final String familyDoctor;
  final String deviceId;

  const UtenteProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.numeroUtente,
    required this.nif,
    required this.birthDate,
    required this.medicalHistory,
    required this.familyDoctor,
    required this.deviceId,
  });

  factory UtenteProfile.empty(String uid, String email) => UtenteProfile(
        uid: uid,
        fullName: '',
        email: email,
        phone: '',
        numeroUtente: '',
        nif: '',
        birthDate: '',
        medicalHistory: '',
        familyDoctor: '',
        deviceId: '',
      );

  factory UtenteProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UtenteProfile(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      numeroUtente: data['numeroUtente'] as String? ?? '',
      nif: data['nif'] as String? ?? '',
      birthDate: data['birthDate'] as String? ?? '',
      medicalHistory: data['medicalHistory'] as String? ?? '',
      familyDoctor: data['familyDoctor'] as String? ?? '',
      deviceId: data['deviceId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'numeroUtente': numeroUtente,
        'nif': nif,
        'birthDate': birthDate,
        'medicalHistory': medicalHistory,
        'familyDoctor': familyDoctor,
        'deviceId': deviceId,
      };
}
