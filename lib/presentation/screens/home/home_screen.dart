import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/models.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final countries = ref.watch(filteredCountriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${countries.length} pays',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isGridView
                  ? _buildGridView(countries)
                  : _buildListView(countries),
            ),
          ],
        ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildGridView(List<Country> countries) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return _buildCountryGridCard(country, index);
      },
    );
  }

  Widget _buildListView(List<Country> countries) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return _buildCountryListTile(country, index);
      },
    );
  }

  Widget _buildCountryGridCard(Country country, int index) {
    final explored = ref.watch(exploredCountriesProvider);
    final isExplored = explored.contains(country.id);

    return GestureDetector(
      onTap: () => context.push('/country/${country.id}'),
      child: Card(
        color: AppColors.getCardColor(index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    country.flagUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: country.flagUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.flag,
                              size: 48,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.flag, size: 48, color: Colors.grey),
                    if (isExplored)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 16, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      country.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (country.capital.isNotEmpty)
                      Text(
                        country.capital,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (50 * index).ms).scale(
            begin: const Offset(0.9, 0.9),
            duration: 300.ms,
          ),
    );
  }

  Widget _buildCountryListTile(Country country, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: country.flagUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: country.flagUrl,
                  width: 48,
                  height: 36,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.flag, size: 32, color: Colors.grey),
                )
              : const Icon(Icons.flag, size: 32, color: Colors.grey),
        ),
        title: Text(
          country.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: country.capital.isNotEmpty
            ? Text(country.capital)
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/country/${country.id}'),
      ),
    ).animate().fadeIn(delay: (30 * index).ms).slideX(begin: 0.1);
  }

  Widget _buildBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.contains('quiz')) currentIndex = 1;
    if (location.contains('progress')) currentIndex = 2;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
          case 1:
            context.go('/quiz');
          case 2:
            context.go('/progress');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: AppStrings.exploreButton,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: AppStrings.quizButton,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Progression',
        ),
      ],
    );
  }
}
