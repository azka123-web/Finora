import 'package:get/get.dart';

import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/signup_view.dart';

import '../../modules/home/views/home_view.dart';

import '../../modules/transactions/bindings/transaction_binding.dart';
import '../../modules/transactions/views/add_transaction_view.dart';
import '../../modules/transactions/views/edit_transaction_view.dart';
import '../../modules/transactions/views/transaction_history_view.dart';

import '../../screens/splash/splash_view.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    // Splash
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),

    // Login
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),

    // Signup
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),

    // Home  ✅ Binding added
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: TransactionBinding(),
    ),

    // Add Transaction
    GetPage(
      name: AppRoutes.addTransaction,
      page: () => const AddTransactionView(),
      binding: TransactionBinding(),
    ),

    // Edit Transaction
    GetPage(
      name: AppRoutes.editTransaction,
      page: () {
        final arguments = Get.arguments as Map;

        return EditTransactionView(
          transactionIndex: arguments['index'],
          transaction: arguments['transaction'],
        );
      },
      binding: TransactionBinding(),
    ),

    // Transaction History  ✅ Binding added
    GetPage(
      name: AppRoutes.transactionHistory,
      page: () => const TransactionHistoryView(),
      binding: TransactionBinding(),
    ),
  ];
}