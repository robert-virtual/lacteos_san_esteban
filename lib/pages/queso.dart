import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Queso extends GetView<UserController> {
  Queso({Key? key}) : super(key: key);
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final textGray = const TextStyle(
    color: Colors.black54,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Queso")),
      body: FutureBuilder<List<List>>(
          future: controller.getSheet("Queso!A:K"),
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
                              "${snap.data![idx][3]} | ${snap.data![idx][2]} lbs producidas",
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Leche Entera usada: ${snap.data![idx][4]} lts ",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Leche Descremada usada: ${snap.data![idx][5]} lts ",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Tipo de Queso: ${snap.data![idx][3]}",
                              textAlign: TextAlign.left,
                              style: textGray,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Sal: ${snap.data![idx][6]}",
                              textAlign: TextAlign.left,
                              style: textGray,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Cuajo: ${snap.data![idx][7]}",
                              textAlign: TextAlign.left,
                              style: textGray,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Suero para Cuajar: ${snap.data![idx][8]} lts",
                              textAlign: TextAlign.left,
                              style: textGray,
                            ),
                            Visibility(
                                visible:
                                    snap.data![idx][3] == "Queso con chile",
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "Chile Jalapeño: ${snap.data![idx][9]}",
                                      textAlign: TextAlign.left,
                                      style: textGray,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      "Chile bolson verde rojo y amarillo: ${snap.data![idx][10]}",
                                      textAlign: TextAlign.left,
                                      style: textGray,
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 10.0),
                            Text(
                              "Registrado por ${snap.data![idx][0]} ",
                              textAlign: TextAlign.left,
                              style: textGray,
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              f.format(DateTime.parse(snap.data![idx][1])),
                              textAlign: TextAlign.left,
                              style: textGray,
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
