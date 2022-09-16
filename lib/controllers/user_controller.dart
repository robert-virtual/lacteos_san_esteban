import 'dart:convert';

import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lateos_san_esteban/pages/form_leche.dart';

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
        getLecheSheet();
      }
    });
    googleSignIn.signInSilently().then((account_) {
      update();
      if (account_ != null) {
        Get.toNamed("/home");
      }
    });
  }

  Future<List<ILeche>> getLecheSheet() async {
    final http.Response res = await http.get(
        Uri.parse('$baseUrl$spreadsheetId/values/Leche!A:D'),
        headers: await account!.authHeaders);
    if (res.statusCode != 200) {
      throw Exception(res.statusCode);
    }
    final Map<String, dynamic> data =
        json.decode(res.body) as Map<String, dynamic>;
    List<ILeche> leche = List.empty();
    List lista = List.from(data["values"]);
    lista.removeAt(0);
    leche =
        lista.map((e) => ILeche(double.parse(e[0]), e[1], e[2], e[3])).toList();
    return leche;
  }

  void setAccount(GoogleSignInAccount _account) {
    account = _account;
    update();
  }
}
