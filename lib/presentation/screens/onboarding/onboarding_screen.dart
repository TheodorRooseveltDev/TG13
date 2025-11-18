import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/presentation/widgets/boss_button.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/app/routes.dart';

/// Onboarding Screen - 3 pages introducing the app
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'LOG EVERY\nCATCH',
      description:
          'Track your catches, record details, and build your fishing legacy - 100% offline.',
      imagePath: 'assets/fish/bass-fish.png',
      backgroundColor: AppColors.deepNavy,
    ),
    OnboardingPage(
      title: 'MASTER YOUR\nSPOTS',
      description:
          'Save your favorite locations, track conditions, and find the perfect fishing spot every time.',
      imagePath: 'assets/navigation-icons/spots.png',
      backgroundColor: AppColors.darkNavy,
    ),
    OnboardingPage(
      title: 'EARN YOUR\nRANK',
      description:
          'Gain XP, unlock achievements, and rise through the ranks from Rookie Angler to Big Boss Fisher.',
      imagePath: 'assets/achivments-badges/big-boss.png',
      backgroundColor: AppColors.deepNavy,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    final appState = context.read<AppStateProvider>();
    await appState.completeOnboarding();
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pages[_currentPage].backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'SKIP',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: AppColors.textLight.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
            
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPageWidget(
                    page: _pages[index],
                    isActive: _currentPage == index,
                  );
                },
              ),
            ),
            
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _PageIndicator(
                    isActive: _currentPage == index,
                  ),
                ),
              ),
            ),
            
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: BossButton(
                text: _currentPage == _pages.length - 1
                    ? 'ENTER THE WATERS'
                    : 'NEXT',
                onPressed: _nextPage,
                icon: _currentPage == _pages.length - 1
                    ? Icons.sailing_rounded
                    : Icons.arrow_forward_rounded,
                width: double.infinity,
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isActive;

  const _OnboardingPageWidget({
    required this.page,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          if (isActive)
            ZoomIn(
              duration: const Duration(milliseconds: 600),
              child: Image.asset(
                page.imagePath,
                width: 280,
                height: 280,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_nature_rounded,
                      size: 120,
                      color: AppColors.textLight.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),
          
          const SizedBox(height: 48),
          
          // Title
          if (isActive)
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 600),
              child: Text(
                page.title,
                style: AppTextStyles.display1.copyWith(
                  color: AppColors.textLight,
                  fontSize: 48,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Description
          if (isActive)
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
              child: Text(
                page.description,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textLight.withOpacity(0.9),
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        gradient: isActive
            ? AppColors.aquaGradient
            : null,
        color: isActive ? null : AppColors.textLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
  });
}
