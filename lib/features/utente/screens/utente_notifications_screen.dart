import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/notifications_repo.dart';

final utenteNotificationsProvider = FutureProvider((ref) async {
  final userId = ref.watch(authRepoProvider).currentUser?.id;
  if (userId == null) return <Map<String, dynamic>>[];
  return ref.watch(notificationsRepoProvider).fetchNotifications(userId);
});

class UtenteNotificationsScreen extends ConsumerWidget {
  const UtenteNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(utenteNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: notifications.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Sem notificações.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final notification = items[index];
              return Card(
                child: ListTile(
                  title: Text(notification['title'] as String),
                  subtitle: Text(notification['message'] as String),
                  trailing: notification['read'] == true
                      ? const Icon(Icons.mark_email_read)
                      : const Icon(Icons.mark_email_unread),
                  onTap: () => ref
                      .read(notificationsRepoProvider)
                      .markRead(notification['id'] as String, true),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
