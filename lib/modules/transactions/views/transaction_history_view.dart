import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/transaction_model.dart';
import '../controllers/transaction_controller.dart';

class TransactionHistoryView extends StatelessWidget {
const TransactionHistoryView({super.key});

@override
Widget build(BuildContext context) {
return GetBuilder<TransactionController>(
builder: (transactionController) {
// ==========================================================
// GET TRANSACTIONS FROM CONTROLLER
// ==========================================================

final transactions =
transactionController.transactions.toList();

// Sort latest transaction first
transactions.sort(
(a, b) => b.date.compareTo(a.date),
);

// ==========================================================
// GET TOTALS FROM CONTROLLER
// ==========================================================

final totalIncome =
transactionController.totalIncome;

final totalExpense =
transactionController.totalExpense;

final balance =
transactionController.balance;

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
leading: IconButton(
onPressed: () => Navigator.pop(context),
icon: const Icon(
Icons.arrow_back_ios_new_rounded,
color: AppColors.darkText,
size: 20,
),
),
title: const Text(
AppStrings.transactionHistory,
style: AppTextStyles.transactionAppBarTitle,
),
),

// ========================================================
// BODY
// ========================================================

body: transactions.isEmpty
? _emptyState()
    : SingleChildScrollView(
physics: const BouncingScrollPhysics(),
padding: const EdgeInsets.fromLTRB(
20,
8,
20,
30,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
// ==================================================
// FINANCIAL OVERVIEW
// ==================================================

Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
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
AppColors.navy.withValues(
alpha: 0.18,
),
blurRadius: 18,
offset: const Offset(0, 8),
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
width: 44,
height: 44,
decoration: BoxDecoration(
color:
AppColors.white13,
borderRadius:
BorderRadius.circular(
14,
),
),
child: const Icon(
Icons
    .account_balance_wallet_rounded,
color:
AppColors.white,
size: 23,
),
),

const SizedBox(width: 12),

const Expanded(
child: Text(
AppStrings
    .financialOverview,
style: AppTextStyles
    .historyOverviewTitle,
),
),
],
),

const SizedBox(height: 22),

const Text(
AppStrings.totalBalance,
style: AppTextStyles
    .historyBalanceLabel,
),

const SizedBox(height: 5),

Text(
'${AppStrings.currencyPrefix}'
'${balance.toStringAsFixed(2)}',
style: AppTextStyles
    .historyBalanceAmount,
),
],
),
),

const SizedBox(height: 18),

// ==================================================
// INCOME & EXPENSE SUMMARY
// ==================================================

Row(
children: [
Expanded(
child: _summaryCard(
title: AppStrings.income,
amount: totalIncome,
icon:
Icons.south_west_rounded,
iconColor:
AppColors.income,
iconBackground:
AppColors
    .incomeBackground,
),
),

const SizedBox(width: 13),

Expanded(
child: _summaryCard(
title: AppStrings.expenses,
amount: totalExpense,
icon:
Icons.north_east_rounded,
iconColor:
AppColors.expense,
iconBackground:
AppColors
    .expenseBackground,
),
),
],
),

const SizedBox(height: 30),

// ==================================================
// ALL TRANSACTIONS HEADER
// ==================================================

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
const Text(
AppStrings.allTransactions,
style: AppTextStyles
    .historySectionTitle,
),

Container(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 6,
),
decoration: BoxDecoration(
color:
AppColors.lightBlue,
borderRadius:
BorderRadius.circular(10),
),
child: Text(
'${transactions.length}',
style: const TextStyle(
color: AppColors.blue,
fontSize: 12,
fontWeight:
FontWeight.w800,
),
),
),
],
),

const SizedBox(height: 5),

const Text(
AppStrings.latestIncomeExpenses,
style:
AppTextStyles.historySubtitle,
),

const SizedBox(height: 16),

// ==================================================
// TRANSACTION LIST
// ==================================================

ListView.builder(
shrinkWrap: true,
physics:
const NeverScrollableScrollPhysics(),
itemCount: transactions.length,
itemBuilder: (context, index) {
final transaction =
transactions[index];

return _transactionCard(
transaction,
);
},
),
],
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
required Color iconColor,
required Color iconBackground,
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
boxShadow: [
BoxShadow(
color: Colors.black.withValues(
alpha: 0.035,
),
blurRadius: 14,
offset: const Offset(0, 6),
),
],
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
width: 43,
height: 43,
decoration: BoxDecoration(
color: iconBackground,
borderRadius:
BorderRadius.circular(14),
),
child: Icon(
icon,
color: iconColor,
size: 22,
),
),

const SizedBox(height: 13),

Text(
title,
style: AppTextStyles.historySummaryTitle,
),

const SizedBox(height: 5),

FittedBox(
fit: BoxFit.scaleDown,
alignment: Alignment.centerLeft,
child: Text(
'${AppStrings.currencyPrefix}'
'${amount.toStringAsFixed(2)}',
style:
AppTextStyles.historySummaryAmount,
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
final isIncome =
transaction.type == 'income';

final Color iconColor = isIncome
? AppColors.income
    : AppColors.expense;

final Color iconBackground = isIncome
? AppColors.incomeBackground
    : AppColors.expenseBackground;

return Container(
width: double.infinity,
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: AppColors.grey200.withValues(
alpha: 0.45,
),
),
boxShadow: [
BoxShadow(
color: Colors.black.withValues(
alpha: 0.03,
),
blurRadius: 12,
offset: const Offset(0, 5),
),
],
),
child: Row(
children: [
// ==========================================================
// TRANSACTION ICON
// ==========================================================

Container(
width: 51,
height: 51,
decoration: BoxDecoration(
color: iconBackground,
borderRadius:
BorderRadius.circular(16),
),
child: Icon(
isIncome
? Icons.south_west_rounded
    : Icons.north_east_rounded,
color: iconColor,
size: 23,
),
),

const SizedBox(width: 13),

// ==========================================================
// TRANSACTION DETAILS
// ==========================================================

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
transaction.title,
maxLines: 1,
overflow:
TextOverflow.ellipsis,
style: AppTextStyles
    .historyTransactionTitle,
),

const SizedBox(height: 6),

Row(
children: [
Icon(
Icons.calendar_today_outlined,
size: 12,
color: AppColors.grey500,
),

const SizedBox(width: 5),

Text(
'${transaction.date.day}/'
'${transaction.date.month}/'
'${transaction.date.year}',
style: AppTextStyles
    .historyTransactionDate,
),
],
),
],
),
),

const SizedBox(width: 8),

// ==========================================================
// AMOUNT + TYPE
// ==========================================================

Column(
crossAxisAlignment:
CrossAxisAlignment.end,
children: [
Text(
'${isIncome ? '+' : '-'} '
'${AppStrings.currencyPrefix}'
'${transaction.amount.toStringAsFixed(2)}',
style: AppTextStyles
    .historyTransactionAmount
    .copyWith(
color: iconColor,
),
),

const SizedBox(height: 6),

Container(
padding:
const EdgeInsets.symmetric(
horizontal: 8,
vertical: 4,
),
decoration: BoxDecoration(
color: iconBackground,
borderRadius:
BorderRadius.circular(8),
),
child: Text(
isIncome
? AppStrings.income
    : AppStrings.expense,
style: AppTextStyles
    .historyTransactionType
    .copyWith(
color: iconColor,
),
),
),
],
),
],
),
);
}

// ================================================================
// EMPTY STATE
// ================================================================

static Widget _emptyState() {
return Center(
child: Padding(
padding: const EdgeInsets.all(30),
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Container(
width: 90,
height: 90,
decoration:
const BoxDecoration(
gradient: LinearGradient(
colors: [
AppColors.lightBlue,
Color(0xFFDCE9FF),
],
),
borderRadius:
BorderRadius.all(
Radius.circular(28),
),
),
child: const Icon(
Icons.receipt_long_rounded,
size: 43,
color: AppColors.blue,
),
),

const SizedBox(height: 22),

const Text(
AppStrings.noTransactionsYet,
style:
AppTextStyles.historyEmptyTitle,
),

const SizedBox(height: 9),

const Text(
AppStrings.trackIncomeExpenses,
textAlign: TextAlign.center,
style: AppTextStyles
    .historyEmptyDescription,
),
],
),
),
);
}
}