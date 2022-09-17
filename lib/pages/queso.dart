import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Queso extends GetView<UserController> {
  const Queso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Queso")),
      body: FutureBuilder<List<List>>(
          future: controller.getSheet("Queso!A:E"),
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return const Center(
                child: Text("Ha ocurrido un error al cargar la informacion"),
              );
            }
            if (snap.isBlank == true) {
              print("no hay datos que mostrar");
              return const Center(child: Text("No hay datos que mostrar"));
            }
            return ListView.builder(
                itemCount: snap.data!.length,
                itemBuilder: (ctx, idx) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      margin: const EdgeInsets.all(12.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${snap.data![idx][2]} | ${snap.data![idx][1]} lbs producidas",
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Leche usada: ${snap.data![idx][0]} lts ",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Tipo de Queso: ${snap.data![idx][2]}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Registrado por ${snap.data![idx][3]} ",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              snap.data![idx][4],
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.black54),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/queso_form");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
