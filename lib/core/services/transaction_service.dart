import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/transaction_model.dart';

class TransactionService {
  final Box<TransactionModel> transactionBox;
  final Box sessionBox;

  TransactionService(
      this.transactionBox,
      this.sessionBox,
      );

  // ================================================================
  // CURRENT USER EMAIL
  // ================================================================

  String get currentUserEmail {
    return sessionBox.get(
      'userEmail',
      defaultValue: '',
    )
        .toString()
        .trim()
        .toLowerCase();
  }

  // ================================================================
  // ADD TRANSACTION
  // ================================================================

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
  }) async {
    final email = currentUserEmail;

    if (email.isEmpty) {
      throw Exception(
        'No logged-in user found.',
      );
    }

    final transaction = TransactionModel(
      title: title.trim(),
      amount: amount,
      type: type.toLowerCase(),
      date: DateTime.now(),
      userEmail: email,
    );

    await transactionBox.add(transaction);
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
    final oldTransaction =
    transactionBox.get(index);

    if (oldTransaction == null) {
      throw Exception(
        'Transaction not found.',
      );
    }

    final updatedTransaction =
    TransactionModel(
      title: title.trim(),
      amount: amount,
      type: type.toLowerCase(),
      date: DateTime.now(),
      userEmail: oldTransaction.userEmail,
    );

    await transactionBox.put(
      index,
      updatedTransaction,
    );
  }

  // ================================================================
  // DELETE TRANSACTION
  // ================================================================

  Future<void> deleteTransaction(
      int index,
      ) async {
    final transaction =
    transactionBox.get(index);

    if (transaction == null) {
      return;
    }

    if (transaction.userEmail !=
        currentUserEmail) {
      return;
    }

    await transactionBox.delete(index);
  }

  // ================================================================
  // CLEAR CURRENT USER TRANSACTIONS
  // ================================================================

  Future<void> clearAllTransactions() async {
    final email = currentUserEmail;

    if (email.isEmpty) {
      return;
    }

    final keysToDelete = transactionBox
        .toMap()
        .entries
        .where(
          (entry) =>
      entry.value.userEmail == email,
    )
        .map((entry) => entry.key)
        .toList();

    await transactionBox.deleteAll(
      keysToDelete,
    );
  }

  // ================================================================
  // CURRENT USER TRANSACTIONS
  // ================================================================

  List<TransactionModel>
  get currentUserTransactions {
    final email = currentUserEmail;

    if (email.isEmpty) {
      return [];
    }

    final list = transactionBox.values
        .where(
          (transaction) =>
      transaction.userEmail == email,
    )
        .toList();

    list.sort(
          (a, b) =>
          b.date.compareTo(a.date),
    );

    return list;
  }

  // ================================================================
  // TOTAL INCOME
  // ================================================================

  double get totalIncome {
    return currentUserTransactions
        .where(
          (transaction) =>
      transaction.type == 'income',
    )
        .fold(
      0.0,
          (sum, transaction) =>
      sum + transaction.amount,
    );
  }

  // ================================================================
  // TOTAL EXPENSE
  // ================================================================

  double get totalExpense {
    return currentUserTransactions
        .where(
          (transaction) =>
      transaction.type == 'expense',
    )
        .fold(
      0.0,
          (sum, transaction) =>
      sum + transaction.amount,
    );
  }

  // ================================================================
  // CURRENT BALANCE
  // ================================================================

  double get balance {
    return totalIncome - totalExpense;
  }

  // ================================================================
  // ALL CURRENT USER TRANSACTIONS
  // ================================================================

  List<TransactionModel>
  get transactions {
    return currentUserTransactions;
  }
}