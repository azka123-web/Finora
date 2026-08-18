import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
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
    try {
      await transactionService.addTransaction(
        title: title,
        amount: amount,
        type: type,
      );

      update();
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.transactionSaveError,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
    try {
      await transactionService.editTransaction(
        index: index,
        title: title,
        amount: amount,
        type: type,
      );

      update();
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.updateTransactionError,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================================================================
  // DELETE TRANSACTION
  // ================================================================

  Future<void> deleteTransaction(int index) async {
    try {
      await transactionService.deleteTransaction(index);

      update();
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.transactionDeleteError,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================================================================
  // CLEAR ALL TRANSACTIONS
  // ================================================================

  Future<void> clearAllTransactions() async {
    try {
      await transactionService.clearAllTransactions();

      update();
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        AppStrings.transactionStorageError,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ================================================================
  // TOTAL INCOME
  // ================================================================

  double get totalIncome {
    try {
      return transactionService.totalIncome;
    } catch (e) {
      return 0.0;
    }
  }

  // ================================================================
  // TOTAL EXPENSE
  // ================================================================

  double get totalExpense {
    try {
      return transactionService.totalExpense;
    } catch (e) {
      return 0.0;
    }
  }

  // ================================================================
  // CURRENT BALANCE
  // ================================================================

  double get balance {
    try {
      return transactionService.balance;
    } catch (e) {
      return 0.0;
    }
  }

  // ================================================================
  // ALL TRANSACTIONS
  // ================================================================

  List<TransactionModel> get transactions {
    try {
      return transactionService.transactions;
    } catch (e) {
      return [];
    }
  }
}