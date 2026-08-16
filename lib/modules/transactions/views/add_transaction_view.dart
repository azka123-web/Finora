import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/transaction_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';

class AddTransactionView extends StatefulWidget {
  const AddTransactionView({super.key});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String selectedType = 'expense';

  bool isLoading = false;
  bool isSaved = false;

  late TransactionController transactionController;

  @override
  void initState() {
    super.initState();

    transactionController = Get.find<TransactionController>();
  }

  Future<void> saveTransaction() async {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();

    // --------------------------------------------------------------
    // TITLE VALIDATION
    // --------------------------------------------------------------

    if (title.isEmpty) {
      Get.snackbar(
        AppStrings.titleRequired,
        AppStrings.enterTransactionTitle,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    // --------------------------------------------------------------
    // AMOUNT VALIDATION
    // --------------------------------------------------------------

    if (amountText.isEmpty) {
      Get.snackbar(
        AppStrings.amountRequired,
        AppStrings.enterTransactionAmount,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      Get.snackbar(
        AppStrings.invalidAmount,
        AppStrings.validAmount,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
      return;
    }

    // --------------------------------------------------------------
    // SAVE TRANSACTION
    // --------------------------------------------------------------

    try {
      setState(() {
        isLoading = true;
        isSaved = false;
      });

      await transactionController.addTransaction(
        title: title,
        amount: amount,
        type: selectedType,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isSaved = true;
      });

      Get.snackbar(
        AppStrings.transactionSaved,
        selectedType == 'income'
            ? AppStrings.incomeAddedSuccessfully
            : AppStrings.expenseAddedSuccessfully,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      Get.back();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isSaved = false;
      });

      Get.snackbar(
        AppStrings.error,
        AppStrings.transactionSaveError,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = selectedType == 'income';

    final Color selectedColor =
    isIncome ? AppColors.income : AppColors.expense;

    final Color selectedBackground =
    isIncome
        ? AppColors.incomeBackground
        : AppColors.expenseBackground;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ==============================================================
      // APP BAR
      // ==============================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: const Text(
          AppStrings.addTransaction,
          style: AppTextStyles.transactionAppBarTitle,
        ),
      ),

      // ==============================================================
      // BODY
      // ==============================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==========================================================
            // HEADER
            // ==========================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.transactionHeaderStart,
                    AppColors.transactionHeaderEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.18),
                    blurRadius: 15,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.white13,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.trackYourMoney,
                          style: AppTextStyles.transactionHeaderTitle,
                        ),
                        SizedBox(height: 4),
                        Text(
                          AppStrings.addIncomeOrExpense,
                          style: AppTextStyles.transactionHeaderSubtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==========================================================
            // TRANSACTION TYPE
            // ==========================================================

            const Text(
              AppStrings.transactionType,
              style: AppTextStyles.transactionSectionTitle,
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _typeCard(
                    title: AppStrings.income,
                    subtitle: AppStrings.moneyReceived,
                    icon: Icons.arrow_downward_rounded,
                    selected: selectedType == 'income',
                    selectedColor: AppColors.income,
                    selectedBackground:
                    AppColors.incomeBackground,
                    onTap: () {
                      setState(() {
                        selectedType = 'income';
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _typeCard(
                    title: AppStrings.expense,
                    subtitle: AppStrings.moneySpent,
                    icon: Icons.arrow_upward_rounded,
                    selected: selectedType == 'expense',
                    selectedColor: AppColors.expense,
                    selectedBackground:
                    AppColors.expenseBackground,
                    onTap: () {
                      setState(() {
                        selectedType = 'expense';
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 27),

            // ==========================================================
            // TRANSACTION TITLE
            // ==========================================================

            const Text(
              AppStrings.transactionTitle,
              style: AppTextStyles.transactionSectionTitle,
            ),

            const SizedBox(height: 10),

            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: AppStrings.transactionTitleHint,
                hintStyle: AppTextStyles.transactionHint,
                filled: true,
                fillColor: AppColors.white,

                prefixIcon: const Icon(
                  Icons.description_outlined,
                  color: AppColors.textGrey,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.grey200,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.blue,
                    width: 1.5,
                  ),
                ),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 17,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ==========================================================
            // AMOUNT
            // ==========================================================

            const Text(
              AppStrings.amount,
              style: AppTextStyles.transactionSectionTitle,
            ),

            const SizedBox(height: 10),

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.enterAmount,
                hintStyle: AppTextStyles.transactionHint,

                filled: true,
                fillColor: AppColors.white,

                prefixIcon: const Icon(
                  Icons.currency_exchange_rounded,
                  color: AppColors.textGrey,
                ),

                prefixText: AppStrings.rupeePrefix,

                prefixStyle:
                AppTextStyles.transactionAmountPrefix,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.grey200,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.blue,
                    width: 1.5,
                  ),
                ),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 17,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==========================================================
            // PREVIEW
            // ==========================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selectedBackground,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: selectedColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIncome
                              ? AppStrings.incomePreview
                              : AppStrings.expensePreview,
                          style: AppTextStyles
                              .transactionPreviewLabel
                              .copyWith(
                            color: selectedColor,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          isIncome
                              ? AppStrings.increaseBalance
                              : AppStrings.decreaseBalance,
                          style: AppTextStyles
                              .transactionPreviewDescription,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==========================================================
            // SAVE BUTTON
            // ==========================================================

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                isLoading || isSaved
                    ? null
                    : saveTransaction,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isSaved
                      ? AppColors.income
                      : AppColors.navy,

                  foregroundColor: AppColors.white,

                  disabledBackgroundColor:
                  isSaved
                      ? AppColors.income
                      : AppColors.grey400,

                  disabledForegroundColor: AppColors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),

                child: isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.white,
                  ),
                )
                    : isSaved
                    ? const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 23,
                    ),
                    SizedBox(width: 9),
                    Text(
                      AppStrings.savedSuccessfully,
                      style:
                      AppTextStyles.transactionButton,
                    ),
                  ],
                )
                    : const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 22,
                    ),
                    SizedBox(width: 9),
                    Text(
                      AppStrings.saveTransaction,
                      style:
                      AppTextStyles.transactionButton,
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

  // ================================================================
  // TRANSACTION TYPE CARD
  // ================================================================

  Widget _typeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required Color selectedColor,
    required Color selectedBackground,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color:
          selected
              ? selectedBackground
              : AppColors.white,

          borderRadius: BorderRadius.circular(17),

          border: Border.all(
            color:
            selected
                ? selectedColor
                : AppColors.grey200,
            width: selected ? 1.5 : 1,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color:
                selected
                    ? AppColors.white
                    : AppColors.transactionIconBackground,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color:
                selected
                    ? selectedColor
                    : AppColors.grey600,
                size: 19,
              ),
            ),

            const SizedBox(width: 7),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles
                        .transactionTypeTitle
                        .copyWith(
                      color:
                      selected
                          ? selectedColor
                          : AppColors.darkText,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                    AppTextStyles.transactionTypeSubtitle,
                  ),
                ],
              ),
            ),

            if (selected) ...[
              const SizedBox(width: 4),

              Icon(
                Icons.check_circle_rounded,
                color: selectedColor,
                size: 17,
              ),
            ],
          ],
        ),
      ),
    );
  }
}