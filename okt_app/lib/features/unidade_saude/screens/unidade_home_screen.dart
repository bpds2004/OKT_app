import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/home_action_card.dart';

class UnidadeHomeScreen extends StatelessWidget {
  const UnidadeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('mockups/logo.png', height: 36),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push('/unidade/notifications'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeActionCard(
                  label: 'Relatórios',
                  icon: Icons.description_outlined,
                  color: AppColors.lightBlue,
                  onTap: () => context.push('/unidade/reports'),
                ),
                HomeActionCard(
                  label: 'Novo Teste',
                  icon: Icons.note_add_outlined,
                  color: AppColors.lightGreen,
                  onTap: () => context.push('/unidade/new-test'),
                ),
                HomeActionCard(
                  label: 'Perfil',
                  icon: Icons.person_outline,
                  color: AppColors.lightOrange,
                  onTap: () => context.push('/unidade/profile'),
                ),
                HomeActionCard(
                  label: 'Pacientes',
                  icon: Icons.group_outlined,
                  color: AppColors.lightOrange.withOpacity(0.6),
                  onTap: () => context.push('/unidade/pacientes'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Artigos do dia', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _ArticleCard(title: 'A Importância da Prevenção do Câncer'),
                  _ArticleCard(title: 'Pesquisa Avançada em Oncologia'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}
