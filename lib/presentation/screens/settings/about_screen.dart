import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A propos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App icon
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.public, size: 56, color: AppColors.primary),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text('AfriMap Explorer',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 4),
            Text('Version 1.0.0', style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 24),

            _InfoCard(
              icon: Icons.lightbulb_outline,
              title: 'Notre mission',
              content: 'AfriMap Explorer est une application educative interactive '
                  'dediee a la decouverte du continent africain. Elle permet aux '
                  'enfants et a tout public d\'apprendre les pays, les regions, '
                  'les langues et les iles d\'Afrique de maniere ludique.',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.school_outlined,
              title: 'Pour qui ?',
              content: 'Concue principalement pour les enfants de 5 a 12 ans, '
                  'l\'application est accessible a tous ceux qui souhaitent '
                  'enrichir leurs connaissances geographiques sur l\'Afrique.',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.offline_bolt_outlined,
              title: 'Fonctionne hors ligne',
              content: 'L\'application fonctionne sans connexion internet. '
                  'Les donnees sont sauvegardees localement et peuvent etre '
                  'synchronisees avec Supabase lorsque vous etes en ligne.',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.code_outlined,
              title: 'Technologies',
              content: 'Flutter, Dart, Riverpod, GoRouter, SharedPreferences, Supabase.',
            ),
            const SizedBox(height: 24),

            // Credits
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  const Text('Credits',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _CreditRow(label: 'Developpement', value: 'AfriMap Team'),
                  _CreditRow(label: 'Design', value: 'Material Design 3'),
                  _CreditRow(label: 'Drapeaux', value: 'flagcdn.com'),
                  _CreditRow(label: 'Backend', value: 'Supabase'),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 24),
            Text('2025 AfriMap Explorer. Tous droits reserves.',
                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _InfoCard({required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(content, style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (200 + title.length * 10).ms).slideX(begin: 0.03);
  }
}

class _CreditRow extends StatelessWidget {
  final String label;
  final String value;
  const _CreditRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}
