import 'package:get/get.dart';

import '../../../core/services/transaction_service.dart';
import '../../../data/models/transaction_model.dart';

class TransactionController extends GetxController {
  final TransactionService transactionService =
  Get.find<TransactionService>();

  // ================================================================
  // ADD TRANSACTION
  // ================================================================

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
  }) async {
    await transactionService.addTransaction(
      title: title,
      amount: amount,
      type: type,
    );

    update();
  }

  // ================================================================
  // EDIT TRANSACTION
  // ================================================================

  Future<void> editTransaction({
    required int index,
    required String title,
    required double amount,
    required String type,
  }) async {
    await transactionService.editTransaction(
      index: index,
      title: title,
      amount: amount,
      type: type,
    );

    update();
  }

  // ================================================================
  // DELETE TRANSACTION
  // ================================================================

  Future<void> deleteTransaction(int index) async {
    await transactionService.deleteTransaction(index);

    update();
  }

  // ================================================================
  // CLEAR ALL TRANSACTIONS
  // ================================================================

  Future<void> clearAllTransactions() async {
    await transactionService.clearAllTransactions();

    update();
  }

  // ================================================================
  // TOTAL INCOME
  // ================================================================

  double get totalIncome {
    return transactionService.totalIncome;
  }

  // ================================================================
  // TOTAL EXPENSE
  // ================================================================

  double get totalExpense {
    return transactionService.totalExpense;
  }

  // ================================================================
  // CURRENT BALANCE
  // ================================================================

  double get balance {
    return transactionService.balance;
  }

  // ================================================================
  // ALL TRANSACTIONS
  // ================================================================

  List<TransactionModel> get transactions {
    return transactionService.transactions;
  }
}