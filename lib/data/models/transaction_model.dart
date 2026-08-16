class TransactionModel {
  final String title;
  final double amount;
  final String type;
  final DateTime date;
  final String userEmail;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.userEmail,
  });
}