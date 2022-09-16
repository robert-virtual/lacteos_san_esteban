import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Mantequilla extends GetView<UserController> {
  const Mantequilla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mantequilla")),
      body: const Center(child: Text("Mantequilla")),
    );
  }
}
