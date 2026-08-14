import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/transaction_model.dart';

class HomeView extends StatelessWidget {
const HomeView({super.key});

Future<void> logout() async {
final sessionBox = Hive.box('sessionBox');

await sessionBox.put('isLoggedIn', false);
await sessionBox.delete('userEmail');

Get.offAllNamed(AppRoutes.login);
}

Future<void> deleteTransaction(
BuildContext context,
Box<TransactionModel> box,
int index,
) async {
final shouldDelete = await showDialog<bool>(
context: context,
builder: (context) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
title: const Text(
'Delete Transaction?',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
content: const Text(
'This transaction will be permanently removed.',
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(context, false);
},
child: const Text('Cancel'),
),
ElevatedButton(
onPressed: () {
Navigator.pop(context, true);
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
foregroundColor: Colors.white,
),
child: const Text('Delete'),
),
],
);
},
);

if (shouldDelete == true) {
await box.delete(index);

Get.snackbar(
'Transaction Deleted',
'The transaction was removed successfully.',
snackPosition: SnackPosition.BOTTOM,
margin: const EdgeInsets.all(15),
);
}
}

void showTransactionOptions(
BuildContext context,
Box<TransactionModel> box,
int index,
TransactionModel transaction,
) {
showModalBottomSheet(
context: context,
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(
top: Radius.circular(25),
),
),
builder: (context) {
return SafeArea(
child: Padding(
padding: const EdgeInsets.only(
top: 10,
bottom: 15,
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 45,
height: 5,
decoration: BoxDecoration(
color: Colors.grey.shade300,
borderRadius: BorderRadius.circular(10),
),
),
const SizedBox(height: 15),

const Text(
'Transaction Options',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

ListTile(
leading: CircleAvatar(
backgroundColor: const Color(0xFFEAF1FF),
child: const Icon(
Icons.edit_outlined,
color: Color(0xFF0A2A66),
),
),
title: const Text(
'Edit Transaction',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),
subtitle: const Text(
'Change title, amount or type',
),
onTap: () {
Navigator.pop(context);

Get.toNamed(
AppRoutes.editTransaction,
arguments: {
'index': index,
'transaction': transaction,
},
);
},
),

ListTile(
leading: CircleAvatar(
backgroundColor: Colors.red.shade50,
child: const Icon(
Icons.delete_outline,
color: Colors.red,
),
),
title: const Text(
'Delete Transaction',
style: TextStyle(
fontWeight: FontWeight.w600,
),
),
subtitle: const Text(
'Remove this transaction',
),
onTap: () {
Navigator.pop(context);

deleteTransaction(
context,
box,
index,
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

@override
Widget build(BuildContext context) {
final sessionBox = Hive.box('sessionBox');

final userEmail = sessionBox.get(
'userEmail',
defaultValue: '',
);

final transactionBox =
Hive.box<TransactionModel>('transactionsBox');

return ValueListenableBuilder(
valueListenable: transactionBox.listenable(),
builder: (
context,
Box<TransactionModel> box,
_,
) {
double totalIncome = 0;
double totalExpense = 0;

for (final transaction in box.values) {
if (transaction.type == 'income') {
totalIncome += transaction.amount;
} else if (transaction.type == 'expense') {
totalExpense += transaction.amount;
}
}

final totalBalance = totalIncome - totalExpense;

final transactionEntries =
box.toMap().entries.toList();

transactionEntries.sort(
(a, b) => b.value.date.compareTo(
a.value.date,
),
);

return Scaffold(
backgroundColor: const Color(0xFFF6F8FC),

appBar: AppBar(
elevation: 0,
backgroundColor: const Color(0xFFF6F8FC),
surfaceTintColor: Colors.transparent,

titleSpacing: 20,

title: const Text(
'Finora',
style: TextStyle(
color: Color(0xFF0A2A66),
fontSize: 24,
fontWeight: FontWeight.w800,
letterSpacing: 0.3,
),
),

actions: [
IconButton(
tooltip: 'Transaction History',
onPressed: () {
Get.toNamed(
AppRoutes.transactionHistory,
);
},
icon: Container(
width: 42,
height: 42,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(13),
),
child: const Icon(
Icons.history_rounded,
color: Color(0xFF0A2A66),
size: 22,
),
),
),

const SizedBox(width: 4),

IconButton(
tooltip: 'Logout',
onPressed: logout,
icon: Container(
width: 42,
height: 42,
decoration: BoxDecoration(
color: Colors.white,
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
// Greeting
Row(
children: [
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFF0A2A66),
Color(0xFF1D63D8),
],
),
borderRadius: BorderRadius.circular(15),
),
child: const Icon(
Icons.person_outline_rounded,
color: Colors.white,
size: 25,
),
),

const SizedBox(width: 12),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Welcome back',
style: TextStyle(
fontSize: 13,
color: Colors.grey.shade600,
fontWeight: FontWeight.w500,
),
),

const SizedBox(height: 3),

Text(
userEmail.toString().isEmpty
? 'Finora User'
    : userEmail.toString(),
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.w700,
color: Color(0xFF172033),
),
),
],
),
),
],
),

const SizedBox(height: 25),

// Balance Card
Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF0A2A66),
Color(0xFF124B9B),
Color(0xFF1675D1),
],
),
borderRadius: BorderRadius.circular(25),
boxShadow: [
BoxShadow(
color: const Color(0xFF0A2A66)
    .withValues(alpha: 0.22),
blurRadius: 20,
offset: const Offset(0, 10),
),
],
),
child: Stack(
children: [
Positioned(
right: -25,
top: -30,
child: Container(
width: 120,
height: 120,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: Colors.white.withValues(
alpha: 0.06,
),
),
),
),

Positioned(
right: 25,
bottom: -45,
child: Container(
width: 100,
height: 100,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: Colors.white.withValues(
alpha: 0.05,
),
),
),
),

Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
padding:
const EdgeInsets.all(8),
decoration: BoxDecoration(
color: Colors.white
    .withValues(alpha: 0.12),
borderRadius:
BorderRadius.circular(10),
),
child: const Icon(
Icons.account_balance_wallet_outlined,
color: Colors.white,
size: 20,
),
),

const SizedBox(width: 10),

const Text(
'Total Balance',
style: TextStyle(
color: Colors.white70,
fontSize: 14,
fontWeight: FontWeight.w500,
),
),
],
),

const SizedBox(height: 17),

Text(
'Rs. ${totalBalance.toStringAsFixed(2)}',
style: const TextStyle(
color: Colors.white,
fontSize: 32,
fontWeight: FontWeight.w800,
letterSpacing: 0.4,
),
),

const SizedBox(height: 8),

Text(
totalBalance >= 0
? 'You are managing your finances well.'
    : 'Your expenses are higher than your income.',
style: const TextStyle(
color: Colors.white70,
fontSize: 12,
),
),
],
),
],
),
),

const SizedBox(height: 20),

// Income & Expense
Row(
children: [
Expanded(
child: _summaryCard(
title: 'Income',
amount: totalIncome,
icon: Icons.arrow_downward_rounded,
iconBackground:
const Color(0xFFE8F7EF),
iconColor: const Color(0xFF159957),
),
),

const SizedBox(width: 14),

Expanded(
child: _summaryCard(
title: 'Expenses',
amount: totalExpense,
icon: Icons.arrow_upward_rounded,
iconBackground:
const Color(0xFFFFEEEE),
iconColor: const Color(0xFFE5484D),
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
'Recent Transactions',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.w800,
color: Color(0xFF172033),
),
),

if (transactionEntries.isNotEmpty)
TextButton(
onPressed: () {
Get.toNamed(
AppRoutes.transactionHistory,
);
},
child: const Text(
'View All',
style: TextStyle(
color: Color(0xFF1769D2),
fontWeight: FontWeight.w700,
),
),
),
],
),

const SizedBox(height: 10),

if (transactionEntries.isEmpty)
_emptyTransactions()
else
Column(
children: transactionEntries
    .take(5)
    .map((entry) {
final index =
entry.key as int;

final transaction =
entry.value;

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
}).toList(),
),
],
),
),

floatingActionButton: Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(18),
boxShadow: [
BoxShadow(
color: const Color(0xFF0A2A66)
    .withValues(alpha: 0.25),
blurRadius: 15,
offset: const Offset(0, 7),
),
],
),
child: FloatingActionButton.extended(
onPressed: () {
Get.toNamed(
AppRoutes.addTransaction,
);
},
backgroundColor: const Color(0xFF0A2A66),
foregroundColor: Colors.white,
elevation: 0,
icon: const Icon(
Icons.add_rounded,
size: 23,
),
label: const Text(
'Add Transaction',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),
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
required Color iconBackground,
required Color iconColor,
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
blurRadius: 12,
offset: const Offset(0, 5),
),
],
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
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
color: Color(0xFF172033),
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
final isIncome =
transaction.type == 'income';

final iconBackground = isIncome
? const Color(0xFFE8F7EF)
    : const Color(0xFFFFEEEE);

final iconColor = isIncome
? const Color(0xFF159957)
    : const Color(0xFFE5484D);

return Container(
width: double.infinity,
margin: const EdgeInsets.only(bottom: 11),
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(19),
border: Border.all(
color: Colors.grey.shade100,
),
boxShadow: [
BoxShadow(
color: Colors.black.withValues(alpha: 0.03),
blurRadius: 10,
offset: const Offset(0, 4),
),
],
),
child: Row(
children: [
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
fontWeight: FontWeight.w700,
fontSize: 15,
color: Color(0xFF172033),
),
),

const SizedBox(height: 5),

Text(
'${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
style: TextStyle(
color: Colors.grey.shade500,
fontSize: 12,
),
),
],
),
),

const SizedBox(width: 8),

Text(
'${isIncome ? '+' : '-'} Rs. ${transaction.amount.toStringAsFixed(2)}',
style: TextStyle(
color: iconColor,
fontWeight: FontWeight.w800,
fontSize: 14,
),
),
],
),
);
}

static Widget _emptyTransactions() {
return Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(
horizontal: 25,
vertical: 35,
),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.grey.shade100,
),
),
child: Column(
children: [
Container(
width: 65,
height: 65,
decoration: BoxDecoration(
color: const Color(0xFFEAF1FF),
borderRadius: BorderRadius.circular(20),
),
child: const Icon(
Icons.receipt_long_outlined,
size: 32,
color: Color(0xFF1769D2),
),
),

const SizedBox(height: 15),

const Text(
'No transactions yet',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.w700,
color: Color(0xFF172033),
),
),

const SizedBox(height: 6),

Text(
'Start tracking your income and expenses\nto manage your money better.',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 13,
height: 1.5,
color: Colors.grey.shade600,
),
),
],
),
);
}
}
