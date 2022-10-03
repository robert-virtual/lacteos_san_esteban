import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Queso extends GetView<UserController> {
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final fDate = DateFormat("dd/MM/yyyy");
  final searchFocus = FocusNode();
  final textGray = const TextStyle(
    color: Colors.black54,
  );
  final searchArguments = [
    "Tipo de queso",
    "Libras Producidas",
    "Registrado por",
    "Fecha"
  ];
  Queso({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Queso"),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                    spacing: 4.0,
                    children: List.generate(
                      searchArguments.length,
                      (i) => Obx(
                        () => ChoiceChip(
                          label: Obx(
                            () => Row(
                              children: [
                                Text(searchArguments[i]),
                                Icon(controller.searchSelectedaArg.value ==
                                        searchArguments[i]
                                    ? Icons.close
                                    : Icons.expand_more)
                              ],
                            ),
                          ),
                          onSelected: (selected) {
                            if (!selected) {
                              controller.searchSelectedaArg.value = "";
                              return;
                            }
                            controller.searchSelectedaArg.value =
                                searchArguments[i];
                            switch (searchArguments[i]) {
                              case "Servicio/Producto":
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                      "Servicio/Producto"),
                                                  TextButton(
                                                      onPressed: () {},
                                                      child:
                                                          const Text("Aplicar"))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                      value: false,
                                                      onChanged: (value) {}),
                                                  const Text(""),
                                                ],
                                              )
                                            ],
                                          ),
                                        ));
                                break;
                              case "Fecha":
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(DateTime.now().year + 5),
                                ).then((x) {
                                  controller.fechaFiltro.value =
                                      x ?? DateTime.now();
                                });
                                break;
                              default:
                            }
                          },
                          selected: controller.searchSelectedaArg.value ==
                              searchArguments[i],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
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
