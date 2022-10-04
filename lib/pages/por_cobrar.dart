import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class PorCobrar extends GetView<UserController> {
  PorCobrar({Key? key}) : super(key: key);
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final nf =
      NumberFormat.currency(locale: "en_HN", decimalDigits: 2, symbol: "L. ");
  final searchArguments = [
    "Producto",
    "Cantidad",
    "Monto",
    "Cliente",
    "Registrado por",
    "Fecha"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
            Text("Ingresos del mes (${nf.format(controller.ingresos.value)})")),
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
                              case "Producto":
                                /* buildShowModalBottomSheet(context); */
                                buildShowModalBottomSheet(
                                  context,
                                  title: searchArguments[i],
                                  datos: controller.productosCobrarCopy,
                                  opciones: controller.productosCobrar,
                                );
                                break;
                              case "Cliente":
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
      body: FutureBuilder<List<List>>(future: () {
        final data = controller.getSheet("CuentasPorCobrar!A:F");
        data.then((value) {
          controller.cuentasCobrar.value = value;
          controller.ingresos.value = controller.cuentasCobrar
              .where(
                  (cc) => DateTime.parse(cc[1]).month == DateTime.now().month)
              .map((e) => double.parse(e[5]))
              .reduce((value, element) => value + element);
        });
        return data;
      }(), builder: (ctx, snap) {
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
        if (!snap.hasData) {
          return const Center(child: Text("No hay datos que mostrar"));
        }
        return Obx(
          () {
            final items = snap.data!
                .where(
                  (e) =>
                      filterName(e[2]) &&
                      filterDate(e[1]) &&
                      filterByCliente(e[4]) &&
                      filterByRegistrador(e[0]),
                )
                .toList();

            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, idx) {
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
                              "Lps. ${items[idx][5]} | ${items[idx][2]}",
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "${items[idx][3]} Libras de ${items[idx][2]} ",
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
                              "Cliente: ${items[idx][4]}",
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
          Get.toNamed("/form_por_cobrar");
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
