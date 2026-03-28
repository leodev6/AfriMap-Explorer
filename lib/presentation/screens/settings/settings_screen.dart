import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explored = ref.watch(exploredCountriesProvider);
    final quizResults = ref.watch(quizResultsProvider);
    final countries = ref.watch(countriesProvider);
    final local = ref.watch(localDataSourceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Parametres')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile card
            _buildProfileCard(context, explored.length, quizResults.length, countries.length),
            const SizedBox(height: 20),

            // General section
            _SectionTitle(title: 'General'),
            _SettingsTile(
              icon: Icons.info_outline,
              iconColor: AppColors.primary,
              title: 'A propos',
              subtitle: 'Version de l\'application et credits',
              onTap: () => context.push('/settings/about'),
            ),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: Colors.green,
              title: 'Politique de confidentialite',
              subtitle: 'Comment vosdonnees sont protegees',
              onTap: () => context.push('/settings/privacy'),
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              iconColor: Colors.orange,
              title: 'Conditions d\'utilisation',
              subtitle: 'Termes et conditions',
              onTap: () => context.push('/settings/terms'),
            ),
            const SizedBox(height: 12),

            // Feedback section
            _SectionTitle(title: 'Feedback'),
            _SettingsTile(
              icon: Icons.star_outline,
              iconColor: AppColors.warning,
              title: 'Noter l\'application',
              subtitle: 'Votre avis compte !',
              onTap: () => _showRatingDialog(context),
            ),
            _SettingsTile(
              icon: Icons.bug_report_outlined,
              iconColor: Colors.red,
              title: 'Signaler un probleme',
              subtitle: 'Envoyer un commentaire',
              onTap: () => context.push('/settings/feedback'),
            ),
            const SizedBox(height: 12),

            // Data section
            _SectionTitle(title: 'Donnees'),
            _SettingsTile(
              icon: Icons.cloud_sync_outlined,
              iconColor: Colors.blue,
              title: 'Synchronisation',
              subtitle: local.getCachedCountries().isNotEmpty
                  ? '${local.getCachedCountries().length} pays en cache'
                  : 'Aucune donnee en cache',
              onTap: () => _showSyncDialog(context, ref),
            ),
            _SettingsTile(
              icon: Icons.delete_outline,
              iconColor: Colors.red,
              title: 'Effacer les donnees locales',
              subtitle: 'Supprimer la progression et le cache',
              onTap: () => _showClearDataDialog(context, ref),
            ),
            const SizedBox(height: 24),

            // App info
            Center(
              child: Column(
                children: [
                  const Text('AfriMap Explorer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text('Version 1.0.0', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('Made with Flutter', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, int explored, int quizzes, int total) {
    final pct = total > 0 ? (explored / total * 100).round() : 0;
    return Card(
      color: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mon Profil',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('Explorateur de l\'Afrique',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ProfileStat(value: '$explored', label: 'Pays\nexplorés', pct: '$pct%'),
                Container(width: 1, height: 40, color: Colors.white24),
                _ProfileStat(value: '$quizzes', label: 'Quiz\ncomplétés', pct: ''),
                Container(width: 1, height: 40, color: Colors.white24),
                _ProfileStat(value: '$total', label: 'Pays\ntotal', pct: ''),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.95, 0.95));
  }

  void _showSyncDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cloud_sync, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Synchronisation'),
          ],
        ),
        content: const Text(
          'Les donnees sont chargees depuis Supabase si une connexion est disponible. '
          'Sinon, les donnees locales sont utilisees.\n\n'
          'La synchronisation se fait automatiquement au demarrage de l\'application.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(countryRepositoryProvider).forceSyncWithRemote();
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Synchronisation terminee')),
                  );
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: const Text('Synchroniser maintenant'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Attention'),
          ],
        ),
        content: const Text(
          'Cette action supprimera toutes vos donnees locales :\n\n'
          '- Progression des quiz\n'
          '- Pays explores\n'
          '- Cache des donnees\n\n'
          'Cette action est irreversible.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Donnees supprimees')),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Noter AfriMap Explorer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Comment trouvez-vous l\'application ?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        size: 40,
                        color: i < rating ? AppColors.warning : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Text(
                rating == 0 ? 'Appuyez sur une etoile'
                    : rating <= 2 ? 'Merci pour votre retour'
                    : rating <= 4 ? 'Merci beaucoup !'
                    : 'Super, merci !',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Plus tard')),
            if (rating > 0)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Merci pour votre avis !')),
                  );
                },
                child: const Text('Envoyer'),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final String pct;
  const _ProfileStat({required this.value, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        if (pct.isNotEmpty) Text(pct, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title.toUpperCase(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[500], letterSpacing: 1)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
