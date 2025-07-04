import 'package:flutter/material.dart';
import 'package:bird_migration_ai/constants/app_colors.dart';
import 'package:bird_migration_ai/constants/app_dimensions.dart';
import 'package:bird_migration_ai/constants/app_text_styles.dart';
import 'package:bird_migration_ai/constants/app_strings.dart';
import 'package:bird_migration_ai/utils/ui_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: AppDimensions.animationSlow),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: AppDimensions.animationNormal),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: AppDimensions.animationFast), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.titleHome),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                _buildHeroSection(),
                
                const SizedBox(height: AppDimensions.spacingXXL),
                
                // Features Section
                UiUtils.buildSectionTitle(AppStrings.discoverTitle),
                const SizedBox(height: AppDimensions.spacingL),
                
                // Feature Cards
                UiUtils.buildFeatureCard(
                  icon: Icons.trending_up,
                  title: AppStrings.featurePredictTitle,
                  description: AppStrings.featurePredictDesc,
                  color: AppColors.sageGreen,
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                UiUtils.buildFeatureCard(
                  icon: Icons.camera_alt,
                  title: AppStrings.featureIdentifyTitle,
                  description: AppStrings.featureIdentifyDesc,
                  color: AppColors.darkGreen,
                ),
                
                const SizedBox(height: AppDimensions.spacingL),
                
                UiUtils.buildFeatureCard(
                  icon: Icons.location_on,
                  title: AppStrings.featureContributeTitle,
                  description: AppStrings.featureContributeDesc,
                  color: AppColors.lightGreen,
                ),
                
                const SizedBox(height: AppDimensions.spacingXXXL),
                
                // Mission Section
                _buildMissionSection(),
                
                const SizedBox(height: AppDimensions.spacingXXL),
                
                // Call to Action
                _buildCallToAction(),
                
                const SizedBox(height: AppDimensions.spacingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppDimensions.shadowBlurL,
            offset: const Offset(0, AppDimensions.shadowOffsetM),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.sageGreen,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: const Icon(
                  Icons.flutter_dash,
                  color: AppColors.textLight,
                  size: AppDimensions.iconL,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingL),
              // Removed duplicate FeatherTrail title here
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Text(
            AppStrings.appTagline,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    return UiUtils.buildGradientContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.eco,
                color: AppColors.darkGreen,
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Text(
                AppStrings.missionTitle,
                style: AppTextStyles.heading5.copyWith(color: AppColors.darkGreen),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            AppStrings.missionText1,
            style: AppTextStyles.bodyMedium.copyWith(color: textColor),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            AppStrings.missionText2,
            style: AppTextStyles.bodyMedium.copyWith(color: textColor, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToAction() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withOpacity(0.3),
            blurRadius: AppDimensions.shadowBlurM,
            offset: const Offset(0, AppDimensions.shadowOffsetM),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.explore,
            color: AppColors.textLight,
            size: AppDimensions.iconXL,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            AppStrings.readyToExplore,
            style: AppTextStyles.heading5.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            AppStrings.exploreDescription,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
