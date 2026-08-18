import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/transaction_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // ================================================================
  // LOCAL ERROR MESSAGES
  // ================================================================
  // These are kept here so HomeView does not depend on AppStrings
  // constants that may not exist in your current AppStrings file.

  static const String _errorTitle = 'Error';

  static const String _logoutErrorMessage =
      'Unable to logout. Please try again.';

  static const String _navigationErrorMessage =
      'Unable to open this screen. Please try again.';

  static const String _transactionOptionsErrorMessage =
      'Unable to open transaction options. Please try again.';

  static const String _deleteErrorMessage =
      'Unable to delete transaction. Please try again.';

  // ================================================================
  // SAFE SNACKBAR
  // ================================================================

  static void _showErrorSnackbar(String message) {
    try {
      Get.snackbar(
        _errorTitle,
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
      );
    } catch (_) {
      // Prevent snackbar errors from causing another exception.
    }
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Future<void> logout() async {
    try {
      final sessionBox = Hive.box('sessionBox');

      await sessionBox.put(
        'isLoggedIn',
        false,
      );

      await sessionBox.delete(
        'userEmail',
      );

      Get.offAllNamed(
        AppRoutes.login,
      );
    } catch (e) {
      _showErrorSnackbar(
        _logoutErrorMessage,
      );
    }
  }

  // ================================================================
  // DELETE TRANSACTION
  // ================================================================

  Future<void> deleteTransaction(
      BuildContext context,
      Box<TransactionModel> box,
      int index,
      ) async {
    try {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              AppStrings.deleteTransactionQuestion,
              style: AppTextStyles.dialogTitle,
            ),
            content: const Text(
              AppStrings.transactionDeleteWarning,
              style: AppTextStyles.dialogContent,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                    false,
                  );
                },
                child: const Text(
                  AppStrings.cancel,
                  style: AppTextStyles.dialogButton,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                    true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.expenseRed,
                  foregroundColor: AppColors.white,
                ),
                child: const Text(
                  AppStrings.delete,
                  style: AppTextStyles.dialogButton,
                ),
              ),
            ],
          );
        },
      );

      if (shouldDelete != true) {
        return;
      }

      if (!context.mounted) {
        return;
      }

      await box.delete(index);

      if (!context.mounted) {
        return;
      }

      try {
        Get.snackbar(
          AppStrings.transactionDeleted,
          AppStrings.transactionRemovedSuccessfully,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
        );
      } catch (_) {
        // Ignore snackbar failure.
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      _showErrorSnackbar(
        _deleteErrorMessage,
      );
    }
  }

  // ================================================================
  // TRANSACTION OPTIONS
  // ================================================================

  void showTransactionOptions(
      BuildContext context,
      Box<TransactionModel> box,
      int index,
      TransactionModel transaction,
      ) {
    try {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        builder: (sheetContext) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ==================================================
                  // SHEET HANDLE
                  // ==================================================

                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  const Text(
                    AppStrings.transactionOptions,
                    style: AppTextStyles.bottomSheetTitle,
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // EDIT
                  // ==================================================

                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      AppColors.lightBlueBackground,
                      child: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.navy,
                      ),
                    ),
                    title: const Text(
                      AppStrings.editTransaction,
                      style: AppTextStyles.optionTitle,
                    ),
                    subtitle: const Text(
                      AppStrings.editTransactionSubtitle,
                      style: AppTextStyles.optionSubtitle,
                    ),
                    onTap: () {
                      try {
                        Navigator.pop(
                          sheetContext,
                        );

                        Get.toNamed(
                          AppRoutes.editTransaction,
                          arguments: {
                            'index': index,
                            'transaction': transaction,
                          },
                        );
                      } catch (e) {
                        _showErrorSnackbar(
                          _navigationErrorMessage,
                        );
                      }
                    },
                  ),

                  // ==================================================
                  // DELETE
                  // ==================================================

                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      AppColors.expenseRed.withValues(
                        alpha: 0.08,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColors.expenseRed,
                      ),
                    ),
                    title: const Text(
                      AppStrings.deleteTransaction,
                      style: AppTextStyles.optionTitle,
                    ),
                    subtitle: const Text(
                      AppStrings.deleteTransactionSubtitle,
                      style: AppTextStyles.optionSubtitle,
                    ),
                    onTap: () {
                      try {
                        Navigator.pop(
                          sheetContext,
                        );

                        deleteTransaction(
                          context,
                          box,
                          index,
                        );
                      } catch (e) {
                        _showErrorSnackbar(
                          _transactionOptionsErrorMessage,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      _showErrorSnackbar(
        _transactionOptionsErrorMessage,
      );
    }
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    // ==============================================================
    // SESSION BOX
    // ==============================================================

    final sessionBox = Hive.box('sessionBox');

    final userEmail = sessionBox
        .get(
      'userEmail',
      defaultValue: '',
    )
        .toString()
        .trim()
        .toLowerCase();

    // ==============================================================
    // TRANSACTION BOX
    // ==============================================================

    final transactionBox = Hive.box<TransactionModel>(
      'transactionsBox',
    );

    // ==============================================================
    // LISTENABLE BUILDER
    // ==============================================================

    return ValueListenableBuilder<Box<TransactionModel>>(
      valueListenable: transactionBox.listenable(),
      builder: (
          context,
          box,
          _,
          ) {
        // ==========================================================
        // CURRENT USER'S TRANSACTIONS ONLY
        // ==========================================================

        final transactionEntries = box
            .toMap()
            .entries
            .where(
              (entry) =>
          entry.value.userEmail.toLowerCase() ==
              userEmail,
        )
            .toList();

        // ==========================================================
        // CALCULATE TOTAL INCOME
        // ==========================================================

        double totalIncome = 0;

        // ==========================================================
        // CALCULATE TOTAL EXPENSE
        // ==========================================================

        double totalExpense = 0;

        for (final entry in transactionEntries) {
          final transaction = entry.value;

          if (transaction.type == 'income') {
            totalIncome += transaction.amount;
          } else if (transaction.type == 'expense') {
            totalExpense += transaction.amount;
          }
        }

        // ==========================================================
        // TOTAL BALANCE
        // ==========================================================

        final totalBalance =
            totalIncome - totalExpense;

        // ==========================================================
        // SORT LATEST FIRST
        // ==============================================================

        transactionEntries.sort(
              (a, b) => b.value.date.compareTo(
            a.value.date,
          ),
        );

        // ==========================================================
        // SCAFFOLD
        // ==========================================================

        return Scaffold(
          backgroundColor: AppColors.background,

          // ========================================================
          // APP BAR
          // ========================================================

          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            titleSpacing: 20,
            title: const Text(
              AppStrings.finora,
              style: AppTextStyles.homeLogo,
            ),
            actions: [
              // ====================================================
              // HISTORY BUTTON
              // ====================================================

              IconButton(
                tooltip: AppStrings.transactionHistory,
                onPressed: () {
                  try {
                    Get.toNamed(
                      AppRoutes.transactionHistory,
                    );
                  } catch (e) {
                    _showErrorSnackbar(
                      _navigationErrorMessage,
                    );
                  }
                },
                icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: AppColors.navy,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // ====================================================
              // LOGOUT BUTTON
              // ====================================================

              IconButton(
                tooltip: AppStrings.logout,
                onPressed: logout,
                icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 12),
            ],
          ),

          // ========================================================
          // BODY
          // ========================================================

          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              5,
              20,
              100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // GREETING
                // ==================================================

                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.navy,
                            AppColors.blue,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.white,
                        size: 25,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.welcomeBack,
                            style: AppTextStyles.welcomeText,
                          ),

                          const SizedBox(height: 3),

                          Text(
                            userEmail.isEmpty
                                ? AppStrings.finoraUser
                                : userEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.userEmail,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ==================================================
                // BALANCE CARD
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.navy,
                        AppColors.blue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navy.withValues(
                          alpha: 0.22,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                              AppColors.white.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons
                                  .account_balance_wallet_outlined,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            AppStrings.totalBalance,
                            style: AppTextStyles.balanceLabel,
                          ),
                        ],
                      ),

                      const SizedBox(height: 17),

                      Text(
                        '${AppStrings.currencyPrefix}'
                            '${totalBalance.toStringAsFixed(2)}',
                        style: AppTextStyles.balanceAmount,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        totalBalance >= 0
                            ? AppStrings.managingFinancesWell
                            : AppStrings.expensesHigherThanIncome,
                        style: AppTextStyles.balanceMessage,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // INCOME & EXPENSE
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        title: AppStrings.income,
                        amount: totalIncome,
                        icon: Icons.arrow_downward_rounded,
                        iconBackground:
                        AppColors.incomeBackground,
                        iconColor: AppColors.incomeGreen,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: _summaryCard(
                        title: AppStrings.expenses,
                        amount: totalExpense,
                        icon: Icons.arrow_upward_rounded,
                        iconBackground:
                        AppColors.expenseBackground,
                        iconColor: AppColors.expenseRed,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ==================================================
                // RECENT TRANSACTIONS HEADER
                // ==================================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.recentTransactions,
                      style: AppTextStyles.sectionTitle,
                    ),

                    if (transactionEntries.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          try {
                            Get.toNamed(
                              AppRoutes.transactionHistory,
                            );
                          } catch (e) {
                            _showErrorSnackbar(
                              _navigationErrorMessage,
                            );
                          }
                        },
                        child: const Text(
                          AppStrings.viewAll,
                          style: AppTextStyles.viewAll,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // ==================================================
                // EMPTY / TRANSACTION LIST
                // ==================================================

                if (transactionEntries.isEmpty)
                  _emptyTransactions()
                else
                  Column(
                    children: transactionEntries
                        .take(5)
                        .map(
                          (entry) {
                        final index = entry.key as int;
                        final transaction = entry.value;

                        return GestureDetector(
                          onLongPress: () {
                            showTransactionOptions(
                              context,
                              box,
                              index,
                              transaction,
                            );
                          },
                          child: _transactionCard(
                            transaction,
                          ),
                        );
                      },
                    )
                        .toList(),
                  ),
              ],
            ),
          ),

          // ========================================================
          // ADD TRANSACTION BUTTON
          // ========================================================

          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(
                    alpha: 0.25,
                  ),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                try {
                  Get.toNamed(
                    AppRoutes.addTransaction,
                  );
                } catch (e) {
                  _showErrorSnackbar(
                    _navigationErrorMessage,
                  );
                }
              },
              backgroundColor: AppColors.navy,
              foregroundColor: AppColors.white,
              elevation: 0,
              icon: const Icon(
                Icons.add_rounded,
                size: 23,
              ),
              label: const Text(
                AppStrings.addTransaction,
                style: AppTextStyles.addTransactionButton,
              ),
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // SUMMARY CARD
  // ================================================================

  static Widget _summaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.grey200.withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: AppTextStyles.summaryTitle,
          ),

          const SizedBox(height: 5),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${AppStrings.currencyPrefix}'
                  '${amount.toStringAsFixed(2)}',
              style: AppTextStyles.summaryAmount,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TRANSACTION CARD
  // ================================================================

  static Widget _transactionCard(
      TransactionModel transaction,
      ) {
    final isIncome = transaction.type == 'income';

    final iconBackground = isIncome
        ? AppColors.incomeBackground
        : AppColors.expenseBackground;

    final iconColor = isIncome
        ? AppColors.incomeGreen
        : AppColors.expenseRed;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 11,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: AppColors.grey200.withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Row(
        children: [
          // ========================================================
          // ICON
          // ========================================================

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          // ========================================================
          // DETAILS
          // ========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.transactionTitle,
                ),

                const SizedBox(height: 5),

                Text(
                  '${transaction.date.day}/'
                      '${transaction.date.month}/'
                      '${transaction.date.year}',
                  style: AppTextStyles.transactionDate,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ========================================================
          // AMOUNT
          // ========================================================

          Flexible(
            child: Text(
              '${isIncome ? '+' : '-'} '
                  '${AppStrings.currencyPrefix}'
                  '${transaction.amount.toStringAsFixed(2)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.transactionAmount.copyWith(
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY TRANSACTIONS
  // ================================================================

  static Widget _emptyTransactions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.grey200.withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 32,
              color: AppColors.blue,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            AppStrings.noTransactionsYet,
            style: AppTextStyles.emptyTitle,
          ),

          const SizedBox(height: 6),

          const Text(
            AppStrings.trackIncomeExpenses,
            textAlign: TextAlign.center,
            style: AppTextStyles.emptyDescription,
          ),
        ],
      ),
    );
  }
}