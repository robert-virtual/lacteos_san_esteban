import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Home extends GetView<UserController> {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      "/queso",
      "/mantequilla",
      "/quesillo",
      "/cuajada",
      "/requeson",
      "/crema"
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Lacteos San Esteban")),
      body: ListView.builder(
          itemCount: pages.length,
          itemBuilder: (ctx, idx) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(pages[idx]);
              },
              child: Card(
                child: ListTile(
                  title: Text(pages[idx]),
                  trailing: const Icon(Icons.arrow_right),
                ),
              ),
            );
          }),
    );
  }
}
