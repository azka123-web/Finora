import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/signup_controller.dart';

import '../../../core/services/auth_services.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/login_service.dart';
import '../../../core/services/signup_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Auth Service
    Get.lazyPut<AuthService>(
          () => AuthService(),
    );

    // Local Storage Service
    Get.lazyPut<LocalStorageService>(
          () => LocalStorageService(),
    );

    // Login Service
    Get.lazyPut<LoginService>(
          () => LoginService(
        Get.find<LocalStorageService>(),
      ),
    );

    // Signup Service
    Get.lazyPut<SignupService>(
          () => SignupService(
        Get.find<LocalStorageService>(),
      ),
    );

    // Login Controller
    Get.lazyPut<LoginController>(
          () => LoginController(),
    );

    // Signup Controller
    Get.lazyPut<SignupController>(
          () => SignupController(),
    );
  }
}