import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class Queso extends GetView<UserController> {
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final f2 = DateFormat("yyyy MMM");
  final nf =
      NumberFormat.currency(locale: "en_HN", decimalDigits: 2, symbol: "L. ");
  final f3 = DateFormat("yyyyMM");
  final fDate = DateFormat("dd/MM/yyyy");
  final searchFocus = FocusNode();
  final textGray = const TextStyle(
    color: Colors.black54,
  );
  final searchArguments = [
    "Tipo de queso",
    /* "Libras Producidas", */
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
                          label: Row(
                            children: [
                              Text(searchArguments[i]),
                              const Icon(Icons.expand_more)
                            ],
                          ),
                          onSelected: (selected) {
                            controller.searchSelectedaArg.value =
                                searchArguments[i];
                            if (!selected) {
                              controller.searchSelectedaArg.value = "";
                            }
                            switch (searchArguments[i]) {
                              case "Tipo de queso":
                                /* buildShowModalBottomSheet(context); */
                                buildShowModalBottomSheet(
                                  context,
                                  title: searchArguments[i],
                                  datos: controller.productosCobrarCopy,
                                  opciones: controller.productosCobrar,
                                );
                                break;
                              case "Libras Producidas":
                                buildShowModalBottomSheet(
                                  context,
                                  title: searchArguments[i],
                                  datos: controller.clientesCopy,
                                  opciones: controller.clientes,
                                );
                                break;
                              case "Registrado por":
                                buildShowModalBottomSheet(
                                  context,
                                  title: searchArguments[i],
                                  datos: controller.registradoresCopy,
                                  opciones: controller.registradores,
                                );
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
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return const Center(
                child: Text(
                  "Ha ocurrido un error al cargar la informacion",
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (snap.data != null) {
              return const Center(child: Text("No hay datos que mostrar"));
            }
            return Obx(
              () {
                final items = snap.data!
                    .where((e) => filterDate(e[1]) && filterName(e[3]))
                    .toList();
                return GroupedListView<List, String>(
                    elements: items,
                    groupBy: (List e) => f3.format(DateTime.parse(e[1])),
                    groupComparator: (v1, v2) =>
                        int.parse(v1).compareTo(int.parse(v2)),
                    order: GroupedListOrder.DESC,
                    useStickyGroupSeparators: true,
                    itemComparator: (e1, e2) =>
                        DateTime.parse(e1[1]).compareTo(DateTime.parse(e2[1])),
                    groupSeparatorBuilder: (value) {
                      final month = int.parse(value.substring(4));
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "${f2.format(DateTime(int.parse(value.substring(0, 4)), month))} (${items.where((cp) => DateTime.parse(cp[1]).month == month).map((e) => double.parse(e[2])).reduce((v, element) => v + element)} Libras)",
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    itemBuilder: (ctx, item) {
                      return Card(
                        margin: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item[3]} | ${item[2]} lbs producidas",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Leche Entera usada: ${item[4]} lts ",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Leche Descremada usada: ${item[5]} lts ",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Tipo de Queso: ${item[3]}",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Sal: ${item[6]}",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Cuajo: ${item[7]}",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Suero para Cuajar: ${item[8]} lts",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                Visibility(
                                    visible: item[3] == "Queso con chile",
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "Chile Jalapeño: ${item[9]}",
                                          textAlign: TextAlign.left,
                                          style: textGray,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "Chile bolson verde rojo y amarillo: ${item[10]}",
                                          textAlign: TextAlign.left,
                                          style: textGray,
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 10.0),
                                Text(
                                  "Registrado por ${item[0]} ",
                                  textAlign: TextAlign.left,
                                  style: textGray,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  f.format(DateTime.parse(item[1])),
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

  Future<dynamic> buildShowModalBottomSheet(
    BuildContext context, {
    title = "Servicio/Producto",
    required RxList<String> datos,
    required RxList<String> opciones,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Aplicar"))
            ],
          ),
          Obx(
            () => Column(
              children: List.generate(
                datos.value.length,
                (idx) => CheckboxListTile(
                  title: Text(datos.value[idx]),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: opciones.value.contains(datos.value[idx]),
                  onChanged: (value) {
                    if (value == true) {
                      opciones.value = [...opciones.value, datos.value[idx]];
                      return;
                    }
                    opciones.value = opciones.value
                        .where((e) => e != datos.value[idx])
                        .toList();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool filterDate(String date) {
    return DateTime.parse(date).isBefore(
      controller.fechaFiltro.value.add(
        const Duration(days: 1),
      ),
    );
  }

  bool filterByRegistrador(String registrador) {
    if (controller.registradores.value.isEmpty) {
      return controller.registradoresCopy.value.contains(registrador);
    }
    return controller.registradores.value.contains(registrador);
  }

  bool filterByCliente(String cliente) {
    if (controller.clientes.value.isEmpty) {
      return controller.clientesCopy.value.contains(cliente);
    }
    return controller.clientes.value.contains(cliente);
  }

  bool filterName(String producto) {
    if (controller.productosCobrar.value.isEmpty) {
      return controller.productosCobrarCopy.value.contains(producto);
    }
    return controller.productosCobrar.value.contains(producto);
  }
}
