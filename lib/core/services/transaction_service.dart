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
    try {
      return sessionBox
          .get(
        'userEmail',
        defaultValue: '',
      )
          .toString()
          .trim()
          .toLowerCase();
    } catch (e) {
      throw Exception(
        'Unable to read the current user session.',
      );
    }
  }

  // ================================================================
  // ADD TRANSACTION
  // ================================================================

  Future<void> addTransaction({
    required String title,
    required double amount,
    required String type,
  }) async {
    try {
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
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to save the transaction.',
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
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to update the transaction.',
      );
    }
  }

  // ================================================================
  // DELETE TRANSACTION
  // ================================================================

  Future<void> deleteTransaction(
      int index,
      ) async {
    try {
      final transaction =
      transactionBox.get(index);

      if (transaction == null) {
        throw Exception(
          'Transaction not found.',
        );
      }

      if (transaction.userEmail !=
          currentUserEmail) {
        throw Exception(
          'You are not allowed to delete this transaction.',
        );
      }

      await transactionBox.delete(index);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to delete the transaction.',
      );
    }
  }

  // ================================================================
  // CLEAR CURRENT USER TRANSACTIONS
  // ================================================================

  Future<void> clearAllTransactions() async {
    try {
      final email = currentUserEmail;

      if (email.isEmpty) {
        throw Exception(
          'No logged-in user found.',
        );
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
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to clear your transactions.',
      );
    }
  }

  // ================================================================
  // CURRENT USER TRANSACTIONS
  // ================================================================

  List<TransactionModel>
  get currentUserTransactions {
    try {
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
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to load your transactions.',
      );
    }
  }

  // ================================================================
  // TOTAL INCOME
  // ================================================================

  double get totalIncome {
    try {
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
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to calculate total income.',
      );
    }
  }

  // ================================================================
  // TOTAL EXPENSE
  // ================================================================

  double get totalExpense {
    try {
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
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to calculate total expenses.',
      );
    }
  }

  // ================================================================
  // CURRENT BALANCE
  // ================================================================

  double get balance {
    try {
      return totalIncome - totalExpense;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to calculate your current balance.',
      );
    }
  }

  // ================================================================
  // ALL CURRENT USER TRANSACTIONS
  // ================================================================

  List<TransactionModel> get transactions {
    try {
      return currentUserTransactions;
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(
        'Unable to load your transactions.',
      );
    }
  }
}