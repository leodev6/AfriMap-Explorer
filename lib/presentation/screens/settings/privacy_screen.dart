import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Politique de confidentialite')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _Section(
              title: '1. Collecte des donnees',
              content: 'AfriMap Explorer ne collecte aucune donnee personnelle '
                  'identifiable. L\'application fonctionne sans inscription ni '
                  'connexion utilisateur.\n\n'
                  'Les seules donnees sauvegardees le sont localement sur votre '
                  'appareil :\n'
                  '- Votre progression dans les quiz\n'
                  '- Les pays que vous avez explores\n'
                  '- Vos scores de quiz',
            ),
            _Section(
              title: '2. Utilisation des donnees',
              content: 'Les donnees locales sont utilisees uniquement pour :\n'
                  '- Sauvegarder votre progression\n'
                  '- Afficher vos statistiques\n'
                  '- Ameliorer votre experience utilisateur\n\n'
                  'Aucune donnee n\'est partagee avec des tiers.',
            ),
            _Section(
              title: '3. Stockage des donnees',
              content: 'Les donnees sont stockees localement sur votre appareil '
                  'en utilisant le systeme de preferences partagees de Flutter '
                  '(SharedPreferences).\n\n'
                  'Vous pouvez supprimer ces donnees a tout moment via les '
                  'parametres de l\'application.',
            ),
            _Section(
              title: '4. Connexion internet',
              content: 'L\'application peut se connecter a Supabase pour '
                  'synchroniser les donnees de contenu (pays, langues, regions). '
                  'Cette connexion est optionnelle et l\'application fonctionne '
                  'pleinement en mode hors ligne.\n\n'
                  'Aucune donnee personnelle n\'est envoyee a Supabase.',
            ),
            _Section(
              title: '5. Images et drapeaux',
              content: 'Les drapeaux des pays sont charges depuis le service '
                  'flagcdn.com. Ces images sont mises en cache localement pour '
                  'un fonctionnement hors ligne.',
            ),
            _Section(
              title: '6. Securite',
              content: 'Nous prenons la securite des donnees au serieux. '
                  'Toutes les donnees restent sur votre appareil et ne sont '
                  'pas transmises a des serveurs tiers sans votre consentement.',
            ),
            _Section(
              title: '7. Enfants',
              content: 'L\'application est congue pour etre sure pour les enfants. '
                  'Aucune donnee personnelle n\'est collectee aupres des enfants. '
                  'Aucune publicite n\'est affichee. Aucun achat integre n\'est propose.',
            ),
            _Section(
              title: '8. Modifications',
              content: 'Cette politique de confidentialite peut etre mise a jour. '
                  'Les modifications seront affichees sur cette page avec la '
                  'date de mise a jour.',
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Derniere mise a jour : Mars 2026',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.privacy_tip, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          const Text('Vosdonnees sont protegees',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('AfriMap Explorer respecte votre vie privee.',
              style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;
  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(content, style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5)),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }
}
