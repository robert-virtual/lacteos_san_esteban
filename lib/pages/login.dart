import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  "https://www.googleapis.com/auth/spreadsheets",
]);

class Login extends GetView<UserController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lacteos San Esteban")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido a Lacteos San Esteban",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            GetBuilder<UserController>(
                builder: (_) => _buildBody(controller.account))
          ],
        )),
      ),
    );
  }

  Widget _buildBody(GoogleSignInAccount? user) {
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              onPressed: () => Get.toNamed("/home"),
              child: const Text("Inicio")),
          ListTile(
              leading: GoogleUserCircleAvatar(identity: user),
              title: Text(user.displayName ?? ""),
              subtitle: Text(user.email)),
          const Text("Inicio de session exitoso"),
          ElevatedButton(
              onPressed: _handleSignout, child: const Text("Cerrar session")),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("Usted no ha iniciado session"),
        ElevatedButton(
            onPressed: _handleSignin, child: const Text("Iniciar session"))
      ],
    );
  }

  Future<void> _handleSignin() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> _handleSignout() => _googleSignIn.disconnect();
}
