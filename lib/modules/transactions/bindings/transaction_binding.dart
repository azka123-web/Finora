import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/services/local_storage_service.dart';
import '../../../core/services/transaction_service.dart';
import '../../../data/models/transaction_model.dart';
import '../controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionService>(
          () => TransactionService(
        Hive.box<TransactionModel>(
          'transactionsBox',
        ),
        Hive.box(
          'sessionBox',
        ),
      ),
    );

    Get.lazyPut<TransactionController>(
          () => TransactionController(),
    );
  }
}