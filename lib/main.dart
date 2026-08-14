import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

import 'data/models/user_model.dart';
import 'data/models/user_model_adapter.dart';

import 'data/models/transaction_model.dart';
import 'data/models/transaction_model_adapter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Open Hive boxes
  await Hive.openBox<UserModel>('usersBox');
  await Hive.openBox<TransactionModel>('transactionsBox');
  await Hive.openBox('sessionBox');

  runApp(const FinoraApp());
}

class FinoraApp extends StatelessWidget {
  const FinoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finora',

      initialRoute: AppRoutes.splash,

      getPages: AppPages.routes,
    );
  }
}