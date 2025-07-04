import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_strings.dart';

class UiUtils {
  // Common alert dialog builder
  static AlertDialog buildAlertDialog({
    required String title,
    required String content,
    String? buttonText,
    required BuildContext context,
  }) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundSecondary,
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
      ),
      content: Text(
        content,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            buttonText ?? AppStrings.alertOk,
            style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
  
  // Common loading indicator
  static Widget buildLoadingIndicator({
    double size = AppDimensions.iconXL,
    Color? color,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.sageGreen.withOpacity(0.7),
        ),
      ),
    );
  }
  
  // Common feature card builder
  static Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppDimensions.shadowBlurM,
            offset: const Offset(0, AppDimensions.shadowOffsetS),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppDimensions.iconM,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  description,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Common section title builder
  static Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading4,
    );
  }
  
  // Common button builder
  static Widget buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: AppDimensions.buttonHeightL,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sageGreen,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXXL,
            vertical: AppDimensions.paddingL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? buildLoadingIndicator(size: AppDimensions.iconM, color: AppColors.textLight)
            : Text(text, style: AppTextStyles.buttonPrimary),
      ),
    );
  }
  
  // Common secondary button builder
  static Widget buildSecondaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: AppDimensions.buttonHeightL,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXXL,
            vertical: AppDimensions.paddingL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? buildLoadingIndicator(size: AppDimensions.iconM, color: AppColors.textLight)
            : Text(text, style: AppTextStyles.buttonPrimary),
      ),
    );
  }
  
  // Common text field builder
  static Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
    );
  }
  
  // Common container with gradient background
  static Widget buildGradientContainer({
    required Widget child,
    List<Color>? colors,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? [
            AppColors.sageGreen.withOpacity(0.1),
            AppColors.darkGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.sageGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: child,
    );
  }
} 