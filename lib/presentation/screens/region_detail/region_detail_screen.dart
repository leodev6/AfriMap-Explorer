import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/models.dart';
import '../../providers/providers.dart';

class RegionDetailScreen extends ConsumerWidget {
  final String countryId;
  final String regionId;
  final String countryName;
  final String regionName;

  const RegionDetailScreen({
    super.key,
    required this.countryId,
    required this.regionId,
    required this.countryName,
    required this.regionName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(languagesByRegionProvider(regionId));
    final officialLangs = languages.where((l) => l.isOfficial).toList();
    final traditionalLangs = languages.where((l) => !l.isOfficial).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(regionName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(countryName, regionName),
            const SizedBox(height: 24),
            _buildSectionTitle(AppStrings.languagesTitle, Icons.language),
            const SizedBox(height: 16),
            if (officialLangs.isNotEmpty) ...[
              _buildLanguageSection(AppStrings.officialLanguages, officialLangs, AppColors.primary),
              const SizedBox(height: 16),
            ],
            if (traditionalLangs.isNotEmpty) ...[
              _buildLanguageSection(AppStrings.traditionalLanguages, traditionalLangs, AppColors.accent),
              const SizedBox(height: 16),
            ],
            if (languages.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'Aucune langue enregistrée pour cette région',
                          style: TextStyle(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildLanguagesCount(languages.length),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String countryName, String regionName) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.location_on, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    regionName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    countryName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1);
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.headline3),
      ],
    );
  }

  Widget _buildLanguageSection(String title, List<Language> langs, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...langs.asMap().entries.map((entry) {
          final index = entry.key;
          final lang = entry.value;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(Icons.translate, color: color, size: 20),
              ),
              title: Text(
                lang.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(lang.type),
            ),
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.05);
        }),
      ],
    );
  }

  Widget _buildLanguagesCount(int count) {
    return Card(
      color: AppColors.getCardColor(count),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.translate, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              '$count langue${count > 1 ? 's' : ''} parlée${count > 1 ? 's' : ''}',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
