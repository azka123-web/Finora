import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/transaction_controller.dart';
import '../../../data/models/transaction_model.dart';

class EditTransactionView extends StatefulWidget {
final int transactionIndex;
final TransactionModel transaction;

const EditTransactionView({
super.key,
required this.transactionIndex,
required this.transaction,
});

@override
State<EditTransactionView> createState() =>
_EditTransactionViewState();
}

class _EditTransactionViewState
extends State<EditTransactionView> {
late TextEditingController titleController;
late TextEditingController amountController;

late String selectedType;

bool isLoading = false;

late TransactionController transactionController;

@override
void initState() {
super.initState();

transactionController =
Get.find<TransactionController>();

titleController = TextEditingController(
text: widget.transaction.title,
);

amountController = TextEditingController(
text: widget.transaction.amount.toString(),
);

selectedType = widget.transaction.type;
}

Future<void> updateTransaction() async {
final title = titleController.text.trim();
final amountText = amountController.text.trim();

if (title.isEmpty) {
Get.snackbar(
'Title Required',
'Please enter a transaction title.',
snackPosition: SnackPosition.BOTTOM,
margin: const EdgeInsets.all(15),
);
return;
}

if (amountText.isEmpty) {
Get.snackbar(
'Amount Required',
'Please enter the transaction amount.',
snackPosition: SnackPosition.BOTTOM,
margin: const EdgeInsets.all(15),
);
return;
}

final amount = double.tryParse(amountText);

if (amount == null || amount <= 0) {
Get.snackbar(
'Invalid Amount',
'Please enter a valid amount greater than zero.',
snackPosition: SnackPosition.BOTTOM,
margin: const EdgeInsets.all(15),
);
return;
}

try {
setState(() {
isLoading = true;
});

await transactionController.editTransaction(
index: widget.transactionIndex,
title: title,
amount: amount,
type: selectedType,
);

if (!mounted) return;

setState(() {
isLoading = false;
});

Get.snackbar(
'Transaction Updated',
'Your transaction was updated successfully.',
snackPosition: SnackPosition.BOTTOM,
margin: const EdgeInsets.all(15),
);

Get.back();
} catch (e) {
if (!mounted) return;

setState(() {
isLoading = false;
});

Get.snackbar(
'Error',
'Something went wrong while updating the transaction.',
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

final Color selectedColor = isIncome
? const Color(0xFF159957)
    : const Color(0xFFE5484D);

final Color selectedBackground = isIncome
? const Color(0xFFE8F7EF)
    : const Color(0xFFFFEEEE);

return Scaffold(
backgroundColor: const Color(0xFFF6F8FC),

appBar: AppBar(
elevation: 0,
backgroundColor: const Color(0xFFF6F8FC),
surfaceTintColor: Colors.transparent,
titleSpacing: 20,
title: const Text(
'Edit Transaction',
style: TextStyle(
color: Color(0xFF172033),
fontSize: 22,
fontWeight: FontWeight.w800,
),
),
),

body: SingleChildScrollView(
physics: const BouncingScrollPhysics(),
padding: const EdgeInsets.fromLTRB(
20,
5,
20,
30,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
// Header
Container(
width: double.infinity,
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF0A2A66),
Color(0xFF1769D2),
],
),
borderRadius:
BorderRadius.circular(22),
boxShadow: [
BoxShadow(
color: const Color(0xFF0A2A66)
    .withValues(alpha: 0.18),
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
color:
Colors.white.withValues(
alpha: 0.13,
),
borderRadius:
BorderRadius.circular(16),
),
child: const Icon(
Icons.edit_note_rounded,
color: Colors.white,
size: 28,
),
),

const SizedBox(width: 14),

const Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Update your transaction',
style: TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.w800,
),
),
SizedBox(height: 4),
Text(
'Make changes to your transaction details.',
style: TextStyle(
color: Colors.white70,
fontSize: 12,
),
),
],
),
),
],
),
),

const SizedBox(height: 28),

// Transaction Type
const Text(
'Transaction Type',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w800,
color: Color(0xFF172033),
),
),

const SizedBox(height: 10),

Row(
children: [
Expanded(
child: _typeCard(
title: 'Income',
subtitle: 'Money received',
icon: Icons.arrow_downward_rounded,
selected:
selectedType == 'income',
selectedColor:
const Color(0xFF159957),
selectedBackground:
const Color(0xFFE8F7EF),
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
title: 'Expense',
subtitle: 'Money spent',
icon: Icons.arrow_upward_rounded,
selected:
selectedType == 'expense',
selectedColor:
const Color(0xFFE5484D),
selectedBackground:
const Color(0xFFFFEEEE),
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

// Transaction Title
const Text(
'Transaction Title',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w800,
color: Color(0xFF172033),
),
),

const SizedBox(height: 10),

TextField(
controller: titleController,
textCapitalization:
TextCapitalization.sentences,
decoration: InputDecoration(
hintText:
'e.g. Grocery, Salary, Transport',
hintStyle: TextStyle(
color: Colors.grey.shade400,
fontSize: 14,
),
filled: true,
fillColor: Colors.white,
prefixIcon: const Icon(
Icons.description_outlined,
color: Color(0xFF64748B),
),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(16),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius:
BorderRadius.circular(16),
borderSide: BorderSide(
color: Colors.grey.shade200,
),
),
focusedBorder: OutlineInputBorder(
borderRadius:
BorderRadius.circular(16),
borderSide: const BorderSide(
color: Color(0xFF1769D2),
width: 1.5,
),
),
contentPadding:
const EdgeInsets.symmetric(
horizontal: 16,
vertical: 17,
),
),
),

const SizedBox(height: 22),

// Amount
const Text(
'Amount',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w800,
color: Color(0xFF172033),
),
),

const SizedBox(height: 10),

TextField(
controller: amountController,
keyboardType:
const TextInputType.numberWithOptions(
decimal: true,
),
decoration: InputDecoration(
hintText: 'Enter amount',
hintStyle: TextStyle(
color: Colors.grey.shade400,
fontSize: 14,
),
filled: true,
fillColor: Colors.white,
prefixIcon: const Icon(
Icons.currency_exchange_rounded,
color: Color(0xFF64748B),
),
prefixText: 'Rs. ',
prefixStyle: const TextStyle(
color: Color(0xFF172033),
fontWeight: FontWeight.w700,
),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(16),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius:
BorderRadius.circular(16),
borderSide: BorderSide(
color: Colors.grey.shade200,
),
),
focusedBorder: OutlineInputBorder(
borderRadius:
BorderRadius.circular(16),
borderSide: const BorderSide(
color: Color(0xFF1769D2),
width: 1.5,
),
),
contentPadding:
const EdgeInsets.symmetric(
horizontal: 16,
vertical: 17,
),
),
),

const SizedBox(height: 25),

// Preview
Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: selectedBackground,
borderRadius:
BorderRadius.circular(17),
),
child: Row(
children: [
Container(
width: 42,
height: 42,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(13),
),
child: Icon(
isIncome
? Icons
    .arrow_downward_rounded
    : Icons
    .arrow_upward_rounded,
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
? 'Income'
    : 'Expense',
style: TextStyle(
fontSize: 12,
color: selectedColor,
fontWeight: FontWeight.w700,
),
),

const SizedBox(height: 3),

Text(
isIncome
? 'This transaction will increase your balance.'
    : 'This transaction will decrease your balance.',
style: TextStyle(
fontSize: 12,
color:
Colors.grey.shade700,
),
),
],
),
),
],
),
),

const SizedBox(height: 28),

// Update Button
SizedBox(
width: double.infinity,
height: 56,
child: ElevatedButton(
onPressed:
isLoading
? null
    : updateTransaction,
style: ElevatedButton.styleFrom(
backgroundColor:
const Color(0xFF0A2A66),
foregroundColor: Colors.white,
disabledBackgroundColor:
Colors.grey.shade400,
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(17),
),
),
child: isLoading
? const SizedBox(
height: 24,
width: 24,
child:
CircularProgressIndicator(
strokeWidth: 2.5,
color: Colors.white,
),
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
'Update Transaction',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w800,
),
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
duration:
const Duration(milliseconds: 200),
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 12,
),
decoration: BoxDecoration(
color: selected
? selectedBackground
    : Colors.white,
borderRadius:
BorderRadius.circular(17),
border: Border.all(
color: selected
? selectedColor
    : Colors.grey.shade200,
width: selected ? 1.5 : 1,
),
),
child: Row(
children: [
Container(
width: 38,
height: 38,
decoration: BoxDecoration(
color: selected
? Colors.white
    : const Color(0xFFF1F4F8),
borderRadius:
BorderRadius.circular(12),
),
child: Icon(
icon,
color: selected
? selectedColor
    : Colors.grey.shade600,
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
overflow:
TextOverflow.ellipsis,
style: TextStyle(
fontSize: 12,
fontWeight: FontWeight.w800,
color: selected
? selectedColor
    : const Color(0xFF172033),
),
),

const SizedBox(height: 2),

Text(
subtitle,
maxLines: 1,
overflow:
TextOverflow.ellipsis,
style: TextStyle(
fontSize: 9,
color: Colors.grey.shade600,
),
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