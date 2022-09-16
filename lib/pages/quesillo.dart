import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Quesillo extends GetView<UserController> {
  const Quesillo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quesillo")),
      body: const Center(child: Text("Quesillo")),
    );
  }
}
