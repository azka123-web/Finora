import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/models/transaction_model.dart';

class TransactionController extends GetxController {
  late Box<TransactionModel> transactionBox;

  @override
  void onInit() {
    super.onInit();

    transactionBox =
        Hive.box<TransactionModel>('transactionsBox');
  }

  // Add transaction
  Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
  }) async {
    final transaction = TransactionModel(
      title: title.trim(),
      amount: amount,
      type: type.toLowerCase(),
      date: DateTime.now(),
    );

    await transactionBox.add(transaction);

    update();
  }

  // Edit transaction
  Future<void> editTransaction({
    required int index,
    required String title,
    required double amount,
    required String type,
  }) async {
    final updatedTransaction = TransactionModel(
      title: title.trim(),
      amount: amount,
      type: type.toLowerCase(),
      date: DateTime.now(),
    );

    await transactionBox.put(
      index,
      updatedTransaction,
    );

    update();
  }

  // Delete transaction
  Future<void> deleteTransaction(int index) async {
    await transactionBox.delete(index);

    update();
  }

  // Clear all old/test transactions
  Future<void> clearAllTransactions() async {
    await transactionBox.clear();

    update();
  }

  // Total income
  double get totalIncome {
    return transactionBox.values
        .where(
          (transaction) =>
      transaction.type.toLowerCase() == 'income',
    )
        .fold(
      0.0,
          (sum, transaction) =>
      sum + transaction.amount,
    );
  }

  // Total expense
  double get totalExpense {
    return transactionBox.values
        .where(
          (transaction) =>
      transaction.type.toLowerCase() == 'expense',
    )
        .fold(
      0.0,
          (sum, transaction) =>
      sum + transaction.amount,
    );
  }

  // Current balance
  double get balance {
    return totalIncome - totalExpense;
  }

  // All transactions
  List<TransactionModel> get transactions {
    return transactionBox.values.toList().reversed.toList();
  }
}