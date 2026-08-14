import 'package:hive/hive.dart';

class TransactionModel {
  final String title;
  final double amount;
  final String type;
  final DateTime date;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });
}