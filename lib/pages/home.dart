import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Home extends GetView<UserController> {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      {"image": "por_pagar", "name": "Cuentas Por Pagar", "route": "/por_pagar"},
      {"image": "por_cobrar", "name": "Cuentas Por Cobrar", "route": "/por_cobrar"},
      {"image": "queso", "name": "Queso", "route": "/queso"},
      {"image": "mantequilla", "name": "Mantequilla", "route": "/mantequilla"},
      {"image": "quesillo", "name": "Quesillo", "route": "/quesillo"},
      {"image": "cuajada", "name": "Cuajada", "route": "/cuajada"},
      {"image": "requeson", "name": "Requeson", "route": "/requeson"},
      {"image": "crema", "name": "Crema", "route": "/crema"}
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Lacteos San Esteban")),
      body: ListView.builder(
          itemCount: pages.length,
          itemBuilder: (ctx, idx) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(pages[idx]["route"]!);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.asset("assets/${pages[idx]["image"]!}.png",
                           width: 100.0),
                      title: Text(pages[idx]["name"]!),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
