import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { utente, unidade }

class AppUser {
  final String uid;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppUser(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      role: (data['role'] as String?) == 'unidade'
          ? UserRole.unidade
          : UserRole.utente,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'role': role == UserRole.unidade ? 'unidade' : 'utente',
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
