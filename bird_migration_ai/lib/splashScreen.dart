import 'package:flutter/material.dart';
import 'package:bird_migration_ai/routeWidget.dart';
import 'package:bird_migration_ai/constants/app_colors.dart';
import 'package:bird_migration_ai/constants/app_dimensions.dart';
import 'package:bird_migration_ai/constants/app_text_styles.dart';
import 'package:bird_migration_ai/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: AppDimensions.animationVerySlow),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: AppDimensions.animationSlow),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: AppDimensions.animationNormal),
      vsync: this,
    );

    // Initialize animations
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start background fade
    _fadeController.forward();
    
    // Wait a bit then start logo animation
    await Future.delayed(const Duration(milliseconds: AppDimensions.animationFast));
    _logoController.forward();
    
    // Wait for logo animation to complete then start text animation
    await Future.delayed(const Duration(milliseconds: AppDimensions.animationNormal));
    _textController.forward();
    
    // Wait for all animations to complete then navigate
    await Future.delayed(const Duration(milliseconds: AppDimensions.animationVerySlow));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const RouteWidget(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: AppDimensions.animationNormal),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backgroundGradient,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Container(
                        width: AppDimensions.iconXXL * 2,
                        height: AppDimensions.iconXXL * 2,
                        decoration: BoxDecoration(
                          color: AppColors.sageGreen,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.sageGreen.withOpacity(0.3),
                              blurRadius: AppDimensions.shadowBlurXL,
                              offset: const Offset(0, AppDimensions.shadowOffsetL),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flutter_dash,
                          color: AppColors.textLight,
                          size: AppDimensions.iconXXL,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.spacingHuge),
                
                // Animated App Title
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textAnimation.value),
                      child: Opacity(
                        opacity: _textController.value,
                        child: Text(
                          AppStrings.appName,
                          style: AppTextStyles.heading1,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                // Animated Subtitle
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textAnimation.value),
                      child: Opacity(
                        opacity: _textController.value,
                        child: Text(
                          AppStrings.appDescription,
                          style: AppTextStyles.subtitle,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppDimensions.spacingMassive),
                
                // Loading indicator
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textController.value,
                      child: SizedBox(
                        width: AppDimensions.iconXL,
                        height: AppDimensions.iconXL,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.sageGreen.withOpacity(0.7),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 