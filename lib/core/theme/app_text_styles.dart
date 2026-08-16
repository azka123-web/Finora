import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ================================================================
  // LOGIN
  // ================================================================

  static const TextStyle loginLogo = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    color: AppColors.navy,
  );

  static const TextStyle loginWelcome = TextStyle(
    fontSize: 29,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle loginBody = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
    height: 1.4,
  );

  static const TextStyle loginFieldLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
  );

  // ================================================================
  // SIGNUP
  // ================================================================

  static const TextStyle signupLogo = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.8,
    color: AppColors.navy,
  );

  static const TextStyle signupHeader = TextStyle(
    color: AppColors.white,
    fontSize: 19,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle signupHeaderSubtitle = TextStyle(
    color: Colors.white70,
    fontSize: 12,
  );

  // ================================================================
  // COMMON FORM FIELDS
  // ================================================================

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle hint = TextStyle(
    color: AppColors.textGrey,
    fontSize: 14,
  );

  // ================================================================
  // BUTTONS
  // ================================================================

  static const TextStyle loginButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle signupButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  // ================================================================
  // LINKS / SMALL TEXT
  // ================================================================

  static const TextStyle forgotPassword = TextStyle(
    color: AppColors.blue,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle orText = TextStyle(
    color: AppColors.textGrey,
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle googleButton = TextStyle(
    color: AppColors.darkText,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle createAccount = TextStyle(
    color: AppColors.textGrey,
    fontSize: 13,
  );

  static const TextStyle createAccountLink = TextStyle(
    color: AppColors.blue,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle signupLoginText = TextStyle(
    color: AppColors.textGrey,
    fontSize: 14,
  );

  static const TextStyle signupLoginLink = TextStyle(
    color: AppColors.blue,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle securityNote = TextStyle(
    fontSize: 11,
    color: Colors.grey,
  );

  static const TextStyle signupSecurityNote = TextStyle(
    fontSize: 12,
    color: Colors.blueGrey,
  );

  // ================================================================
  // HOME
  // ================================================================

  static const TextStyle homeLogo = TextStyle(
    color: AppColors.navy,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.3,
  );

  static const TextStyle welcomeText = TextStyle(
    fontSize: 13,
    color: AppColors.grey600,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle userEmail = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
  );

  static const TextStyle balanceLabel = TextStyle(
    color: Colors.white70,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle balanceAmount = TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.4,
  );

  static const TextStyle balanceMessage = TextStyle(
    color: Colors.white70,
    fontSize: 12,
  );

  static const TextStyle summaryTitle = TextStyle(
    fontSize: 13,
    color: AppColors.grey600,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle summaryAmount = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle viewAll = TextStyle(
    color: AppColors.blue,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle transactionTitle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: AppColors.darkText,
  );

  static const TextStyle transactionDate = TextStyle(
    color: AppColors.grey500,
    fontSize: 12,
  );

  static const TextStyle transactionAmount = TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 14,
  );

  static const TextStyle emptyTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
  );

  static const TextStyle emptyDescription = TextStyle(
    fontSize: 13,
    height: 1.5,
    color: AppColors.grey600,
  );

  static const TextStyle addTransactionButton = TextStyle(
    fontWeight: FontWeight.w700,
  );

  // ================================================================
  // DIALOG
  // ================================================================

  static const TextStyle dialogTitle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const TextStyle dialogContent = TextStyle();

  static const TextStyle dialogButton = TextStyle();

  // ================================================================
  // BOTTOM SHEET / TRANSACTION OPTIONS
  // ================================================================

  static const TextStyle bottomSheetTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle optionTitle = TextStyle(
    fontWeight: FontWeight.w600,
  );

  static const TextStyle optionSubtitle = TextStyle();

  // ================================================================
  // ADD / EDIT TRANSACTION
  // ================================================================

  static const TextStyle transactionAppBarTitle = TextStyle(
    color: AppColors.darkText,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle transactionHeaderTitle = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle transactionHeaderSubtitle = TextStyle(
    color: AppColors.white70,
    fontSize: 12,
  );

  static const TextStyle transactionSectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle transactionHint = TextStyle(
    color: AppColors.grey400,
    fontSize: 14,
  );

  static const TextStyle transactionAmountPrefix = TextStyle(
    color: AppColors.darkText,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle transactionPreviewLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle transactionPreviewDescription = TextStyle(
    fontSize: 12,
    color: AppColors.grey700,
  );

  static const TextStyle transactionTypeTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle transactionTypeSubtitle = TextStyle(
    fontSize: 9,
    color: AppColors.grey600,
  );

  static const TextStyle transactionButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  // ================================================================
  // TRANSACTION HISTORY
  // ================================================================

  static const TextStyle historyAppBarTitle = TextStyle(
    color: AppColors.darkText,
    fontSize: 21,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle historyOverviewTitle = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle historyBalanceLabel = TextStyle(
    color: Colors.white70,
    fontSize: 13,
  );

  static const TextStyle historyBalanceAmount = TextStyle(
    color: AppColors.white,
    fontSize: 29,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle historySummaryTitle = TextStyle(
    fontSize: 13,
    color: AppColors.grey600,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle historySummaryAmount = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle historySectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle historySubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.grey600,
  );

  static const TextStyle historyTransactionTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
  );

  static const TextStyle historyTransactionDate = TextStyle(
    fontSize: 11,
    color: AppColors.grey500,
  );

  static const TextStyle historyTransactionAmount = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle historyTransactionType = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle historyEmptyTitle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w800,
    color: AppColors.darkText,
  );

  static const TextStyle historyEmptyDescription = TextStyle(
    fontSize: 14,
    height: 1.5,
    color: AppColors.grey600,
  );
}