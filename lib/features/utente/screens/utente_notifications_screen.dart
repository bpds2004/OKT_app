import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/repositories/providers.dart';
import '../../auth/controllers/auth_controller.dart';

class UtenteNotificationsScreen extends ConsumerWidget {
  const UtenteNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepoProvider).currentUser;
    if (user == null) {
      return const OktScaffold(title: 'Notificações', child: Text('Sem sessão.'));
    }
    return OktScaffold(
      title: 'Notificações',
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: ref.read(notificationsRepoProvider).fetchNotifications(user.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notifications = snapshot.data!;
          if (notifications.isEmpty) {
            return const Center(child: Text('Sem notificações.'));
          }
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = notifications[index];
              return ListTile(
                title: Text(item['title']),
                subtitle: Text(item['message']),
                trailing: item['read'] == true
                    ? const Icon(Icons.done)
                    : const Icon(Icons.new_releases),
              );
            },
          );
        },
      ),
    );
  }
}
