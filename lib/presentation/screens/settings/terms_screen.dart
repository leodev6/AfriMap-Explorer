import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conditions d\'utilisation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _Section(
              title: '1. Acceptation des conditions',
              content: 'En utilisant AfriMap Explorer, vous acceptez les presentes '
                  'conditions d\'utilisation. Si vous n\'acceptez pas ces conditions, '
                  'veuillez ne pas utiliser l\'application.',
            ),
            _Section(
              title: '2. Description du service',
              content: 'AfriMap Explorer est une application educative gratuite qui '
                  'permet de decouvrir les pays d\'Afrique, leurs regions, langues '
                  'et iles a travers des quiz interactifs.',
            ),
            _Section(
              title: '3. Utilisation autorisee',
              content: 'L\'application est destinee a un usage personnel et educatif. '
                  'Vous pouvez :\n'
                  '- Utiliser l\'application gratuitement\n'
                  '- Sauvegarder votre progression localement\n'
                  '- Partager vos resultats avec vos amis',
            ),
            _Section(
              title: '4. Propriete intellectuelle',
              content: 'Le contenu de l\'application (textes, design, code) est '
                  'protege par le droit d\'auteur. Les drapeaux des pays sont '
                  'des emblemes nationaux et sont utilises a des fins educatives.',
            ),
            _Section(
              title: '5. Limitation de responsabilite',
              content: 'L\'application est fournie "en l\'etat". Nous nous efforcons '
                  'de fournir des informations exactes mais ne garantissons pas '
                  'l\'exactitude de toutes les donnees geographiques.',
            ),
            _Section(
              title: '6. Disponibilite',
              content: 'Nous nous reservons le droit de modifier, suspendre ou '
                  'arreter l\'application a tout moment sans preavis.',
            ),
            const SizedBox(height: 20),
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
      child: const Column(
        children: [
          Icon(Icons.description, size: 48, color: AppColors.primary),
          SizedBox(height: 12),
          Text('Conditions d\'utilisation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Veuillez lire ces conditions attentivement',
              style: TextStyle(color: Colors.grey)),
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
