import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/models/transaction_model.dart';

class TransactionHistoryView extends StatelessWidget {
const TransactionHistoryView({super.key});

static const Color navy = Color(0xFF0A2A66);
static const Color blue = Color(0xFF1769D2);
static const Color background = Color(0xFFF6F8FC);
static const Color darkText = Color(0xFF172033);
static const Color green = Color(0xFF159957);
static const Color red = Color(0xFFE5484D);

@override
Widget build(BuildContext context) {
final transactionBox =
Hive.box<TransactionModel>('transactionsBox');

return ValueListenableBuilder(
valueListenable: transactionBox.listenable(),
builder: (
context,
Box<TransactionModel> box,
_,
) {
final entries = box.toMap().entries.toList();

entries.sort(
(a, b) => b.value.date.compareTo(a.value.date),
);

double totalIncome = 0;
double totalExpense = 0;

for (final transaction in box.values) {
if (transaction.type == 'income') {
totalIncome += transaction.amount;
} else if (transaction.type == 'expense') {
totalExpense += transaction.amount;
}
}

final balance = totalIncome - totalExpense;

return Scaffold(
backgroundColor: background,

appBar: AppBar(
elevation: 0,
backgroundColor: background,
surfaceTintColor: Colors.transparent,
leading: IconButton(
onPressed: () => Navigator.pop(context),
icon: const Icon(
Icons.arrow_back_ios_new_rounded,
color: darkText,
size: 20,
),
),
title: const Text(
'Transaction History',
style: TextStyle(
color: darkText,
fontSize: 21,
fontWeight: FontWeight.w800,
),
),
),

body: entries.isEmpty
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
// Balance Header
Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
navy,
blue,
],
),
borderRadius:
BorderRadius.circular(24),
boxShadow: [
BoxShadow(
color: navy.withValues(alpha: 0.18),
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
color: Colors.white
    .withValues(alpha: 0.13),
borderRadius:
BorderRadius.circular(14),
),
child: const Icon(
Icons
    .account_balance_wallet_rounded,
color: Colors.white,
size: 23,
),
),
const SizedBox(width: 12),
const Text(
'Financial Overview',
style: TextStyle(
color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.w700,
),
),
],
),

const SizedBox(height: 22),

const Text(
'Current Balance',
style: TextStyle(
color: Colors.white70,
fontSize: 13,
),
),

const SizedBox(height: 5),

Text(
'Rs. ${balance.toStringAsFixed(2)}',
style: const TextStyle(
color: Colors.white,
fontSize: 29,
fontWeight: FontWeight.w800,
),
),
],
),
),

const SizedBox(height: 18),

// Income & Expense
Row(
children: [
Expanded(
child: _summaryCard(
title: 'Income',
amount: totalIncome,
icon: Icons.south_west_rounded,
iconColor: green,
iconBackground:
const Color(0xFFE8F7EF),
),
),
const SizedBox(width: 13),
Expanded(
child: _summaryCard(
title: 'Expenses',
amount: totalExpense,
icon: Icons.north_east_rounded,
iconColor: red,
iconBackground:
const Color(0xFFFFEEEE),
),
),
],
),

const SizedBox(height: 30),

// Section heading
Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
const Text(
'All Transactions',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.w800,
color: darkText,
),
),
Container(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 6,
),
decoration: BoxDecoration(
color: const Color(0xFFEAF1FF),
borderRadius:
BorderRadius.circular(10),
),
child: Text(
'${entries.length}',
style: const TextStyle(
color: blue,
fontSize: 12,
fontWeight: FontWeight.w800,
),
),
),
],
),

const SizedBox(height: 5),

Text(
'Your latest income and expenses',
style: TextStyle(
fontSize: 13,
color: Colors.grey.shade600,
),
),

const SizedBox(height: 16),

// Transactions
ListView.builder(
shrinkWrap: true,
physics:
const NeverScrollableScrollPhysics(),
itemCount: entries.length,
itemBuilder: (context, index) {
final transaction =
entries[index].value;

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
color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.grey.shade100,
),
boxShadow: [
BoxShadow(
color: Colors.black.withValues(alpha: 0.035),
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
borderRadius: BorderRadius.circular(14),
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
style: TextStyle(
fontSize: 13,
color: Colors.grey.shade600,
fontWeight: FontWeight.w500,
),
),

const SizedBox(height: 5),

FittedBox(
fit: BoxFit.scaleDown,
alignment: Alignment.centerLeft,
child: Text(
'Rs. ${amount.toStringAsFixed(2)}',
style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.w800,
color: darkText,
),
),
),
],
),
);
}

static Widget _transactionCard(
TransactionModel transaction,
) {
final isIncome = transaction.type == 'income';

final iconColor = isIncome ? green : red;

final iconBackground = isIncome
? const Color(0xFFE8F7EF)
    : const Color(0xFFFFEEEE);

return Container(
width: double.infinity,
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.grey.shade100,
),
boxShadow: [
BoxShadow(
color: Colors.black.withValues(alpha: 0.03),
blurRadius: 12,
offset: const Offset(0, 5),
),
],
),
child: Row(
children: [
// Transaction icon
Container(
width: 51,
height: 51,
decoration: BoxDecoration(
color: iconBackground,
borderRadius: BorderRadius.circular(16),
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

// Transaction details
Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
transaction.title,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: darkText,
),
),

const SizedBox(height: 6),

Row(
children: [
Icon(
Icons.calendar_today_outlined,
size: 12,
color: Colors.grey.shade500,
),
const SizedBox(width: 5),
Text(
'${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
style: TextStyle(
fontSize: 11,
color: Colors.grey.shade500,
),
),
],
),
],
),
),

const SizedBox(width: 8),

// Amount + type
Column(
crossAxisAlignment:
CrossAxisAlignment.end,
children: [
Text(
'${isIncome ? '+' : '-'} Rs. ${transaction.amount.toStringAsFixed(2)}',
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w800,
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
isIncome ? 'Income' : 'Expense',
style: TextStyle(
fontSize: 9,
fontWeight: FontWeight.w800,
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
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFFEAF1FF),
Color(0xFFDCE9FF),
],
),
borderRadius:
BorderRadius.circular(28),
),
child: const Icon(
Icons.receipt_long_rounded,
size: 43,
color: blue,
),
),

const SizedBox(height: 22),

const Text(
'No Transactions Yet',
style: TextStyle(
fontSize: 21,
fontWeight: FontWeight.w800,
color: darkText,
),
),

const SizedBox(height: 9),

Text(
'Your income and expenses will appear\n'
'here once you add your first transaction.',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 14,
height: 1.5,
color: Colors.grey.shade600,
),
),
],
),
),
);
}
}