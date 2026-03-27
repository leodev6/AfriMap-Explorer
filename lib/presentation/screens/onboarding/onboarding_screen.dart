import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
      icon: Icons.public,
      color: AppColors.primary,
    ),
    _OnboardingPage(
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
      icon: Icons.explore,
      color: AppColors.accent,
    ),
    _OnboardingPage(
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
      icon: Icons.quiz,
      color: AppColors.success,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page);
                },
              ),
            ),
            _buildDots(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      widget.onComplete();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _pages[_currentPage].color,
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1
                        ? AppStrings.nextButton
                        : AppStrings.startButton,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
            ),
            if (_currentPage < _pages.length - 1)
              TextButton(
                onPressed: widget.onComplete,
                child: const Text(
                  AppStrings.skipButton,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 72,
              color: page.color,
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .fadeIn(),
          const SizedBox(height: 48),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline2.copyWith(
              color: page.color,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 20),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? _pages[_currentPage].color
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
