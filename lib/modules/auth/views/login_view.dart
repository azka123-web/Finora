import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

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
                20,
                22,
                25,
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
                          width: 78,
                          height: 78,
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
                            BorderRadius.circular(24),
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
                            size: 38,
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Text(
                          AppStrings.appName,
                          style: AppTextStyles.loginLogo,
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          AppStrings.smartMoneyManagement,
                          style: AppTextStyles.loginBody,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 42),

                  // ==================================================
                  // WELCOME
                  // ==================================================

                  const Text(
                    AppStrings.welcomeBack,
                    style: AppTextStyles.loginWelcome,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    AppStrings.loginDescription,
                    style: AppTextStyles.loginBody,
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // LOGIN CARD
                  // ==================================================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                      BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.borderColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withValues(
                            alpha: 0.035,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        // ==================================================
                        // EMAIL
                        // ==================================================

                        const Text(
                          AppStrings.emailAddress,
                          style:
                          AppTextStyles.loginFieldLabel,
                        ),

                        const SizedBox(height: 9),

                        TextField(
                          controller:
                          controller.emailController,
                          keyboardType:
                          TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText:
                            AppStrings.enterYourEmail,
                            hintStyle:
                            AppTextStyles.hint,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.blue,
                              size: 21,
                            ),
                            filled: true,
                            fillColor:
                            AppColors.inputBackground,
                            contentPadding:
                            const EdgeInsets.symmetric(
                              vertical: 17,
                            ),
                            border:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                15,
                              ),
                              borderSide:
                              BorderSide.none,
                            ),
                            enabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                15,
                              ),
                              borderSide:
                              const BorderSide(
                                color:
                                AppColors.borderColor,
                              ),
                            ),
                            focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                15,
                              ),
                              borderSide:
                              const BorderSide(
                                color: AppColors.blue,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 21),

                        // ==================================================
                        // PASSWORD
                        // ==================================================

                        const Text(
                          AppStrings.password,
                          style:
                          AppTextStyles.loginFieldLabel,
                        ),

                        const SizedBox(height: 9),

                        Obx(
                              () => TextField(
                            controller:
                            controller
                                .passwordController,
                            obscureText: controller
                                .isPasswordHidden.value,
                            decoration: InputDecoration(
                              hintText:
                              AppStrings.enterYourPassword,
                              hintStyle:
                              AppTextStyles.hint,
                              prefixIcon: const Icon(
                                Icons
                                    .lock_outline_rounded,
                                color: AppColors.blue,
                                size: 21,
                              ),
                              suffixIcon: IconButton(
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
                              filled: true,
                              fillColor:
                              AppColors.inputBackground,
                              contentPadding:
                              const EdgeInsets.symmetric(
                                vertical: 17,
                              ),
                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  15,
                                ),
                                borderSide:
                                BorderSide.none,
                              ),
                              enabledBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  15,
                                ),
                                borderSide:
                                const BorderSide(
                                  color:
                                  AppColors.borderColor,
                                ),
                              ),
                              focusedBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  15,
                                ),
                                borderSide:
                                const BorderSide(
                                  color: AppColors.blue,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ==================================================
                        // FORGOT PASSWORD
                        // ==================================================

                        Align(
                          alignment:
                          Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 4,
                              ),
                            ),
                            child: const Text(
                              AppStrings.forgotPassword,
                              style: AppTextStyles
                                  .forgotPassword,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ==================================================
                        // LOGIN BUTTON
                        // ==================================================

                        Obx(
                              () => SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: controller
                                  .isLoading.value
                                  ? null
                                  : controller.login,
                              style: ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                AppColors.navy,
                                foregroundColor:
                                AppColors.white,
                                disabledBackgroundColor:
                                AppColors.navy
                                    .withValues(
                                  alpha: 0.55,
                                ),
                                elevation: 0,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(15),
                                ),
                              ),
                              child:
                              controller.isLoading.value
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color:
                                  AppColors
                                      .white,
                                ),
                              )
                                  : const Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                                children: [
                                  Text(
                                    AppStrings.login,
                                    style:
                                    AppTextStyles
                                        .loginButton,
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Icon(
                                    Icons
                                        .arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ==================================================
                  // OR
                  // ==================================================

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color:
                          Colors.grey.shade300,
                        ),
                      ),

                      const Padding(
                        padding:
                        EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Text(
                          AppStrings.or,
                          style:
                          AppTextStyles.orText,
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          color:
                          Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // GOOGLE LOGIN
                  // ==================================================

                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      height: 53,
                      child: OutlinedButton(
                        onPressed: controller
                            .isGoogleLoading.value
                            ? null
                            : controller
                            .loginWithGoogle,
                        style: OutlinedButton
                            .styleFrom(
                          backgroundColor:
                          AppColors.white,
                          disabledBackgroundColor:
                          AppColors.white,
                          side: const BorderSide(
                            color:
                            AppColors.borderColor,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                        child: controller
                            .isGoogleLoading.value
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color:
                            AppColors.blue,
                          ),
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              width: 21,
                              height: 21,
                            ),
                            const SizedBox(
                              width: 11,
                            ),
                            const Text(
                              AppStrings
                                  .continueWithGoogle,
                              style:
                              AppTextStyles
                                  .googleButton,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // CREATE ACCOUNT
                  // ==================================================

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.signup,
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text:
                          AppStrings.dontHaveAccount,
                          style: AppTextStyles
                              .createAccount,
                          children: const [
                            TextSpan(
                              text:
                              ' ${AppStrings.createAccount}',
                              style: AppTextStyles
                                  .createAccountLink,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // ==================================================
                  // SECURITY NOTE
                  // ==================================================

                  Center(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 13,
                          color:
                          Colors.grey.shade500,
                        ),

                        const SizedBox(width: 5),

                        const Text(
                          AppStrings
                              .financialDataPrivate,
                          style: AppTextStyles
                              .securityNote,
                        ),
                      ],
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
}