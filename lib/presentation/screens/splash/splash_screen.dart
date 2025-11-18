import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';
import 'package:big_boss_fishing/core/constants/app_constants.dart';
import 'package:big_boss_fishing/providers/app_state_provider.dart';
import 'package:big_boss_fishing/app/routes.dart';
import 'package:big_boss_fishing/presentation/screens/webview/webview_screen.dart';

/// Splash Screen - Big Boss Fishing
/// Shows for 3 seconds with animations then navigates to onboarding or home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for app state to load
    final appState = context.read<AppStateProvider>();
    
    // Ensure state is loaded before checking firstLaunch
    if (appState.isLoading) {
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return appState.isLoading;
      });
    }
    
    // Wait for splash duration
    await Future.delayed(AppConstants.splashDuration);
    
    if (!mounted) return;
    
    // Check if first launch
    final shouldShowOnboarding = appState.firstLaunch;
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
        shouldShowOnboarding ? AppRoutes.onboarding : AppRoutes.home,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/splash-screen.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon with scale animation
                  ZoomIn(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.bossAqua,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.bossAqua.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // App Title
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'BIG BOSS',
                      style: AppTextStyles.display1.copyWith(
                        fontSize: 52,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Text(
                      'FISHING',
                      style: AppTextStyles.display1.copyWith(
                        fontSize: 52,
                        color: AppColors.bossAqua,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Tagline
                  FadeIn(
                    delay: const Duration(milliseconds: 800),
                    child: Text(
                      'Master the Waters',
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.metalSilver,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Loading indicator at bottom
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: FadeIn(
                delay: const Duration(milliseconds: 1000),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.bossAqua),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            
            // Privacy Policy and Terms links
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeIn(
                delay: const Duration(milliseconds: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WebViewScreen(
                              url: 'https://bigbosfishing.com/privacy-policy',
                              title: 'Privacy Policy',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.metalSilver,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.metalSilver,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '•',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.metalSilver,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WebViewScreen(
                              url: 'https://bigbosfishing.com/terms-and-conditions',
                              title: 'Terms of Service',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Terms of Service',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.metalSilver,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.metalSilver,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
