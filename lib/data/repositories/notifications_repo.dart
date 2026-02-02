import '../supabase/supabase_client.dart';

class NotificationsRepo {
  Future<List<Map<String, dynamic>>> fetchNotifications(String userId) async {
    final response = await SupabaseClientFactory.client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response;
  }

  Future<void> markRead(String notificationId) async {
    await SupabaseClientFactory.client
        .from('notifications')
        .update({'read': true})
        .eq('id', notificationId);
  }

  Future<void> createNotification(Map<String, dynamic> data) async {
    await SupabaseClientFactory.client.from('notifications').insert(data);
  }
}
