import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class PorPagar extends GetView<UserController> {
  PorPagar({Key? key}) : super(key: key);
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final searchArguments = [
    "Servicio/Producto",
    "Cantidad",
    "Monto",
    "Proveedor",
    "Registrado por",
    "Fecha"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuentas por Pagar"),
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
                                /* showModalBottomSheet( */
                                /*     context: context, */
                                /*     builder: (context) => Padding( */
                                /*           padding: const EdgeInsets.all(8.0), */
                                /*           child: Column( */
                                /*             children: [ */
                                /*               Row( */
                                /*                 mainAxisAlignment: */
                                /*                     MainAxisAlignment */
                                /*                         .spaceBetween, */
                                /*                 children: [ */
                                /*                   const Text( */
                                /*                       "Servicio/Producto"), */
                                /*                   ElevatedButton( */
                                /*                       onPressed: () { */
                                /*                         Navigator.of(context) */
                                /*                             .pop(); */
                                /*                       }, */
                                /*                       child: */
                                /*                           const Text("Aplicar")) */
                                /*                 ], */
                                /*               ), */
                                /*               FutureBuilder<List<List>>( */
                                /*                   future: controller */
                                /*                       .getSheet("Metadata!A:A"), */
                                /*                   builder: (ctx, snap) { */
                                /*                     if (!snap.hasData) { */
                                /*                       return const Center( */
                                /*                           child: */
                                /*                               CircularProgressIndicator()); */
                                /*                     } */
                                /*                     if (snap.hasError) { */
                                /*                       return const Center( */
                                /*                         child: Text( */
                                /*                             "Ha ocurrido un error al cargar la informacion"), */
                                /*                       ); */
                                /*                     } */
                                /*                     if (snap.isBlank == true) { */
                                /*                       return const Center( */
                                /*                           child: Text( */
                                /*                               "No hay datos que mostrar")); */
                                /*                     } */
                                /*                     return Column( */
                                /*                       children: List.generate( */
                                /*                           snap.data!.length, */
                                /*                           (idx) => Row( */
                                /*                                 children: [ */
                                /*                                   Checkbox( */
                                /*                                       value: */
                                /*                                           false, */
                                /*                                       onChanged: */
                                /*                                           (value) {}), */
                                /*                                   Text(snap */
                                /*                                           .data![ */
                                /*                                       idx][0]), */
                                /*                                 ], */
                                /*                               )), */
                                /*                     ); */
                                /*                   }), */
                                /*             ], */
                                /*           ), */
                                /*         )); */
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
        actions: [
          IconButton(
              onPressed: () {
                controller.searching.value = !controller.searching.value;
              },
              icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(DateTime.now().year + 5));
            },
            icon: const Icon(
              Icons.date_range,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<List>>(
          future: controller.getSheet("CuentasPorPagar!A:G"),
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
                                  "Lps. ${items[idx][6]} | ${items[idx][2]}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "${items[idx][2]} ${items[idx][3]} ${items[idx][4]}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Registrado por ${items[idx][0]} ",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Proveedor: ${items[idx][5]}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  f.format(DateTime.parse(items[idx][1])),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.black54),
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
          Get.toNamed("/form_por_pagar");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
