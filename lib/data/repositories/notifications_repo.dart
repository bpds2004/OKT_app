import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class NotificationsRepository {
  NotificationsRepository(this._client);

  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> fetchNotifications(String userId) async {
    final data = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<void> markRead(String notificationId, bool read) {
    return _client
        .from('notifications')
        .update({'read': read})
        .eq('id', notificationId);
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
  }) {
    return _client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'message': message,
    });
  }
}

final notificationsRepoProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(SupabaseClientFactory.client),
);
