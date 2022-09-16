import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
              "Bienvenido a la app de Lacteos San Esteban",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            _buildBody()
          ],
        )),
      ),
    );
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = controller.account;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListTile(
              leading: GoogleUserCircleAvatar(identity: user),
              title: Text(user.displayName ?? ""),
              subtitle: Text(user.email)),
          const Text("Inicio de session exitoso"),
          ElevatedButton(
              onPressed: _handleSignout, child: const Text("Cerrar session")),
          ElevatedButton(
              onPressed: () => controller.handleGetSheets(user),
              child: const Text("Refresh"))
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("Usted no ha iniciado session"),
        ElevatedButton(onPressed: _handleSignin, child: const Text("Signin"))
      ],
    );
  }

  Future<void> _handleSignin() async {
    try {
      await controller.googleSignIn.signIn();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> _handleSignout() => controller.googleSignIn.disconnect();
}
