import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Leche extends GetView<UserController> {
  Leche({Key? key}) : super(key: key);
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leche")),
      body: FutureBuilder<List<List>>(
          future: controller.getSheet("Leche!A:D"),
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
                              "${snap.data![idx][2]} lts ",
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Registrado por ${snap.data![idx][0]} ",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Proveedor: ${snap.data![idx][3]}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              f.format(DateTime.parse(snap.data![idx][1])),
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
          Get.toNamed("/leche_form");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
