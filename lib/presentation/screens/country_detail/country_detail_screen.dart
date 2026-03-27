import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/models.dart';
import '../../providers/providers.dart';

class CountryDetailScreen extends ConsumerStatefulWidget {
  final String countryId;

  const CountryDetailScreen({super.key, required this.countryId});

  @override
  ConsumerState<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends ConsumerState<CountryDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exploredCountriesProvider.notifier).addCountry(widget.countryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final countries = ref.watch(countriesProvider);
    final country = countries.firstWhere(
      (c) => c.id == widget.countryId,
      orElse: () => Country(id: '', name: 'Inconnu', flagUrl: '', capital: ''),
    );

    if (country.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pays introuvable')),
        body: const Center(child: Text('Ce pays n\'existe pas')),
      );
    }

    final regions = ref.watch(regionsByCountryProvider(widget.countryId));
    final languages = ref.watch(languagesByCountryProvider(widget.countryId));
    final islands = ref.watch(islandsByCountryProvider(widget.countryId));

    final officialLangs = languages.where((l) => l.isOfficial).toList();
    final traditionalLangs = languages.where((l) => !l.isOfficial).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlagCard(country),
            const SizedBox(height: 20),
            _buildInfoCard(country),
            const SizedBox(height: 20),
            if (islands.isNotEmpty) ...[
              _buildSectionTitle(AppStrings.islandsTitle, Icons.beach_access),
              const SizedBox(height: 12),
              _buildIslandsList(islands),
              const SizedBox(height: 20),
            ],
            _buildSectionTitle(AppStrings.languagesTitle, Icons.language),
            const SizedBox(height: 12),
            if (officialLangs.isNotEmpty) ...[
              _buildLanguageSection(AppStrings.officialLanguages, officialLangs, AppColors.primary),
              const SizedBox(height: 12),
            ],
            if (traditionalLangs.isNotEmpty) ...[
              _buildLanguageSection(AppStrings.traditionalLanguages, traditionalLangs, AppColors.accent),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            _buildSectionTitle(AppStrings.regionsTitle, Icons.location_on),
            const SizedBox(height: 12),
            _buildRegionsList(context, ref, regions, country),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagCard(Country country) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: country.flagUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: country.flagUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.flag,
                  size: 64,
                  color: Colors.grey,
                ),
              )
            : const Icon(Icons.flag, size: 64, color: Colors.grey),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildInfoCard(Country country) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.location_city, color: AppColors.primary, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.capital,
                  style: AppTextStyles.bodySmall,
                ),
                Text(
                  country.capital.isNotEmpty ? country.capital : 'Non renseigné',
                  style: AppTextStyles.headline3,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1);
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

  Widget _buildIslandsList(List<Island> islands) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: islands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Chip(
            avatar: const Icon(Icons.beach_access, size: 18),
            label: Text(islands[index].name),
            backgroundColor: AppColors.getCardColor(index),
          ).animate().fadeIn(delay: (100 * index).ms);
        },
      ),
    );
  }

  Widget _buildLanguageSection(String title, List<Language> langs, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: langs.map((lang) {
            return Chip(
              label: Text(lang.name),
              backgroundColor: color.withOpacity(0.15),
              labelStyle: TextStyle(color: color, fontWeight: FontWeight.w500),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRegionsList(
    BuildContext context,
    WidgetRef ref,
    List<Region> regions,
    Country country,
  ) {
    if (regions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Aucune région enregistrée'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: regions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final region = regions[index];
        final regionLangs = ref.watch(languagesByRegionProvider(region.id));

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.getCardColor(index),
              child: const Icon(Icons.location_on, color: AppColors.primary),
            ),
            title: Text(
              region.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: regionLangs.isNotEmpty
                ? Text(
                    regionLangs.map((l) => l.name).join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(
              '/country/${country.id}/region/${region.id}',
              extra: {'countryName': country.name, 'regionName': region.name},
            ),
          ),
        ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.05);
      },
    );
  }
}
