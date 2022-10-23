import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends GetView<UserController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lácteos San Esteban")),
      body: Obx(
        () => controller.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GetBuilder<UserController>(
                builder: (_) => _buildBody(controller.account),
              ),
      ),
    );
  }

  Widget _buildBody(GoogleSignInAccount? user) {
    if (user != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/san_esteban.jpg"),
            ElevatedButton(
                onPressed: () => Get.toNamed("/home"),
                child: const Text("Inicio")),
            ListTile(
                leading: GoogleUserCircleAvatar(identity: user),
                title: Text(user.displayName ?? ""),
                subtitle: Text(user.email)),
            const Text("Inicio de sesión exitoso"),
            ElevatedButton(
              onPressed: _handleSignout,
              child: const Text("Cerrar sesión"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset("assets/san_esteban.jpg"),
          const SizedBox(height: 10),
          const Text("Usted no ha iniciado sesión"),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15.0))),
            onPressed: _handleSignin,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/google.png",
                  height: 25.0,
                ),
                const SizedBox(width: 25),
                const Text("Iniciar sesión con Google"),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _handleSignin() async {
    try {
      await controller.googleSignIn.signIn();
    } catch (e) {
      Get.snackbar(
          "Error", "Ha habido un error al iniciar sesión intenta más tarde");
    }
  }

  Future<void> _handleSignout() async {
    controller.googleSignIn.disconnect();
    controller.account = null;
  }
}
