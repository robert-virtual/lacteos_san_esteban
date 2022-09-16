import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}

class UserController extends GetxController {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    "https://www.googleapis.com/auth/spreadsheets",
  ]);
  GoogleSignInAccount? account;
  void setAccount(GoogleSignInAccount _account) {
    account = _account;
    update();
  }
}
