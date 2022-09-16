import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Cuajada extends GetView<UserController> {
  const Cuajada({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuajada")),
      body: const Center(child: Text("Cuajada")),
    );
  }
}
