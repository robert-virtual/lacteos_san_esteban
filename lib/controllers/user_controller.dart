import 'dart:convert';

import 'package:get/get.dart';
import "package:http/http.dart" as http;
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
  final spreadsheetId = "1hlcv__-71at852uml7TOKA_AS90qlkOQvcHOk-yq1bQ";
  final baseUrl = "https://sheets.googleapis.com/v4/spreadsheets/";
  GoogleSignInAccount? account;

  @override
  void onInit() {
    super.onInit();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? _account) {
      account = _account;
      update();
      if (account != null) {
        handleGetSheets(_account!);
      }
    });
    googleSignIn.signInSilently();
  }

  Future<void> handleGetSheets(GoogleSignInAccount account) async {
    /* _contactText = "Loading contact info..."; */
    /* update(); */
    final http.Response res = await http.get(
        Uri.parse('${baseUrl}${spreadsheetId}/values/{Leche!A:D}'),
        headers: await account.authHeaders);
    if (res.statusCode != 200) {
      /* _contactText = "People api gave a ${res.statusCode} response."; */
      /* update(); */
      return;
    }
    final Map<String, dynamic> data =
        json.decode(res.body) as Map<String, dynamic>;
    /* final String? namedContact = _pickFirstNamedContact(data); */
    /* if (namedContact != null) { */
    /*   _contactText = "I see you know $namedContact !!"; */
    /* } else { */
    /*   _contactText = "no contacts to display"; */
    /* } */
    /* update(); */
  }

  void setAccount(GoogleSignInAccount _account) {
    account = _account;
    update();
  }
}
