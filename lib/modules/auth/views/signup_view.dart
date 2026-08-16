import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                18,
                22,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ==================================================
                  // TOP LOGO
                  // ==================================================

                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.navy,
                                AppColors.blue,
                              ],
                            ),
                            borderRadius:
                            BorderRadius.circular(21),
                            boxShadow: [
                              BoxShadow(
                                color:
                                AppColors.blue.withValues(
                                  alpha: 0.20,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons
                                .account_balance_wallet_rounded,
                            color: AppColors.white,
                            size: 36,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          AppStrings.signupLogo,
                          style: AppTextStyles.signupLogo,
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          AppStrings.smartMoneyManagement,
                          style: AppTextStyles.loginBody,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ==================================================
                  // HEADER
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.navy,
                          AppColors.blue,
                        ],
                      ),
                      borderRadius:
                      BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color:
                          AppColors.navy.withValues(
                            alpha: 0.16,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                            AppColors.white.withValues(
                              alpha: 0.13,
                            ),
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons
                                .person_add_alt_1_rounded,
                            color: AppColors.white,
                            size: 27,
                          ),
                        ),

                        const SizedBox(width: 14),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings
                                    .createYourAccount,
                                style: AppTextStyles
                                    .signupHeader,
                              ),
                              SizedBox(height: 5),
                              Text(
                                AppStrings
                                    .startManagingMoney,
                                style: AppTextStyles
                                    .signupHeaderSubtitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // FULL NAME
                  // ==================================================

                  const Text(
                    AppStrings.fullName,
                    style: AppTextStyles.fieldLabel,
                  ),

                  const SizedBox(height: 9),

                  TextField(
                    controller:
                    controller.nameController,
                    textCapitalization:
                    TextCapitalization.words,
                    decoration: _inputDecoration(
                      hint:
                      AppStrings.enterYourFullName,
                      icon:
                      Icons.person_outline_rounded,
                    ),
                  ),

                  const SizedBox(height: 19),

                  // ==================================================
                  // EMAIL
                  // ==================================================

                  const Text(
                    AppStrings.email,
                    style: AppTextStyles.fieldLabel,
                  ),

                  const SizedBox(height: 9),

                  TextField(
                    controller:
                    controller.emailController,
                    keyboardType:
                    TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      hint: AppStrings.enterYourEmail,
                      icon: Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 19),

                  // ==================================================
                  // PASSWORD
                  // ==================================================

                  const Text(
                    AppStrings.password,
                    style: AppTextStyles.fieldLabel,
                  ),

                  const SizedBox(height: 9),

                  Obx(
                        () => TextField(
                      controller:
                      controller.passwordController,
                      obscureText: controller
                          .isPasswordHidden.value,
                      decoration: _inputDecoration(
                        hint: AppStrings
                            .createStrongPassword,
                        icon:
                        Icons.lock_outline_rounded,
                        suffix: IconButton(
                          onPressed: controller
                              .togglePasswordVisibility,
                          icon: Icon(
                            controller
                                .isPasswordHidden
                                .value
                                ? Icons
                                .visibility_off_outlined
                                : Icons
                                .visibility_outlined,
                            color:
                            AppColors.textGrey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 19),

                  // ==================================================
                  // CONFIRM PASSWORD
                  // ==================================================

                  const Text(
                    AppStrings.confirmPassword,
                    style: AppTextStyles.fieldLabel,
                  ),

                  const SizedBox(height: 9),

                  Obx(
                        () => TextField(
                      controller: controller
                          .confirmPasswordController,
                      obscureText: controller
                          .isConfirmPasswordHidden.value,
                      decoration: _inputDecoration(
                        hint: AppStrings
                            .confirmYourPassword,
                        icon:
                        Icons.lock_outline_rounded,
                        suffix: IconButton(
                          onPressed: controller
                              .toggleConfirmPasswordVisibility,
                          icon: Icon(
                            controller
                                .isConfirmPasswordHidden
                                .value
                                ? Icons
                                .visibility_off_outlined
                                : Icons
                                .visibility_outlined,
                            color:
                            AppColors.textGrey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 27),

                  // ==================================================
                  // CREATE ACCOUNT BUTTON
                  // ==================================================

                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          AppColors.navy,
                          foregroundColor:
                          AppColors.white,
                          disabledBackgroundColor:
                          AppColors.navy.withValues(
                            alpha: 0.55,
                          ),
                          elevation: 3,
                          shadowColor:
                          AppColors.navy.withValues(
                            alpha: 0.20,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(17),
                          ),
                        ),
                        child:
                        controller.isLoading.value
                            ? const SizedBox(
                          width: 23,
                          height: 23,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color:
                            AppColors.white,
                          ),
                        )
                            : const Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            Icon(
                              Icons
                                  .person_add_alt_1_rounded,
                              size: 21,
                            ),
                            SizedBox(width: 9),
                            Text(
                              AppStrings
                                  .createAccount,
                              style:
                              AppTextStyles
                                  .signupButton,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // SECURITY NOTE
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.blue,
                          size: 18,
                        ),

                        const SizedBox(width: 9),

                        const Expanded(
                          child: Text(
                            AppStrings
                                .financialInformationPrivate,
                            style: AppTextStyles
                                .signupSecurityNote,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // LOGIN
                  // ==================================================

                  Center(
                    child: TextButton(
                      onPressed: Get.back,
                      child: Text.rich(
                        TextSpan(
                          text: AppStrings
                              .alreadyHaveAccount,
                          style: AppTextStyles
                              .signupLoginText,
                          children: const [
                            TextSpan(
                              text:
                              ' ${AppStrings.login}',
                              style: AppTextStyles
                                  .signupLoginLink,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // REUSABLE INPUT DECORATION
  // ==============================================================

  static InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.hint,

      prefixIcon: Icon(
        icon,
        color: AppColors.textGrey,
        size: 21,
      ),

      suffixIcon: suffix,

      filled: true,
      fillColor: AppColors.white,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.borderColor,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.blue,
          width: 1.5,
        ),
      ),
    );
  }
}