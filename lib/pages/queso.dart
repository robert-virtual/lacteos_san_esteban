import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Queso extends GetView<UserController> {
  const Queso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lacteos San Esteban")),
      body: const Center(child: Text("Queso")),
    );
  }
}
