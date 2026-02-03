import 'package:cloud_firestore/cloud_firestore.dart';

class HealthUnitProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String code;
  final String deviceId;

  const HealthUnitProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.code,
    required this.deviceId,
  });

  factory HealthUnitProfile.empty(String uid, String email) => HealthUnitProfile(
        uid: uid,
        name: '',
        email: email,
        phone: '',
        address: '',
        code: '',
        deviceId: '',
      );

  factory HealthUnitProfile.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return HealthUnitProfile(
      uid: doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      code: data['code'] as String? ?? '',
      deviceId: data['deviceId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'code': code,
        'deviceId': deviceId,
      };
}
