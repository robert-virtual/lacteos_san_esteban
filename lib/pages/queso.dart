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
      appBar: AppBar(
        title: const Text("Queso"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(DateTime.now().year + 5),
              ).then((x) {
                controller.fechaFiltro.value = x ?? DateTime.now();
                print("dia:${controller.fechaFiltro.value.day} ");
                Get.snackbar("fecha", "${controller.fechaFiltro.value.day}");
              });
            },
            icon: const Icon(
              Icons.date_range,
            ),
          )
        ],
      ),
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
            return Obx(
              () {
                final items = snap.data!
                    .where((e) => DateTime.parse(e[1]).isBefore(controller
                        .fechaFiltro.value
                        .add(const Duration(days: 1))))
                    .toList();
                return ListView.builder(
                    itemCount: items.length,
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
                                  "${items[idx][3]} | ${items[idx][2]} lbs producidas",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Leche Entera usada: ${items[idx][4]} lts ",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Leche Descremada usada: ${items[idx][5]} lts ",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Tipo de Queso: ${items[idx][3]}",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Sal: ${items[idx][6]}",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Cuajo: ${items[idx][7]}",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Suero para Cuajar: ${items[idx][8]} lts",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                Visibility(
                                    visible: items[idx][3] == "Queso con chile",
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "Chile Jalapeño: ${items[idx][9]}",
                                          textAlign: TextAlign.left,
                                          style: textGray,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "Chile bolson verde rojo y amarillo: ${items[idx][10]}",
                                          textAlign: TextAlign.left,
                                          style: textGray,
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Registrado por ${items[idx][0]} ",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  f.format(DateTime.parse(items[idx][1])),
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            );
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
