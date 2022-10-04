import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class PorPagar extends GetView<UserController> {
  PorPagar({Key? key}) : super(key: key);
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final nf =
      NumberFormat.currency(locale: "en_HN", decimalDigits: 2, symbol: "L. ");
  final searchArguments = [
    "Servicio/Producto",
    "Monto",
    "Proveedor",
    "Registrado por",
    "Fecha"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () =>
              Text("Egresos del mes (${nf.format(controller.egresos.value)})"),
        ),
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
                              case "Servicio/Producto":
                                /* buildShowModalBottomSheet(context); */
                                buildShowModalBottomSheet(
                                  context,
                                  title: searchArguments[i],
                                  datos: controller.serviciosProductosPagarCopy,
                                  opciones: controller.serviciosProductosPagar,
                                );
                                break;
                              case "Proveedor":
                                buildShowModalBottomSheet(
                                  context,
                                  title: searchArguments[i],
                                  datos: controller.proveedoresCopy,
                                  opciones: controller.proveedores,
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
        final data = controller.getSheet("CuentasPorPagar!A:G");
        data.then((value) {
          controller.cuentasPagar.value = value;
          controller.egresos.value = controller.cuentasPagar
              .where(
                  (cp) => DateTime.parse(cp[1]).month == DateTime.now().month)
              .map((e) => double.parse(e[6]))
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
                      filterByProveedor(e[5]) &&
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

  bool filterByProveedor(String proveedor) {
    if (controller.proveedores.value.isEmpty) {
      return controller.proveedoresCopy.value.contains(proveedor);
    }
    return controller.proveedores.value.contains(proveedor);
  }

  bool filterName(String servicioProducto) {
    if (controller.serviciosProductosPagar.value.isEmpty) {
      return controller.serviciosProductosPagarCopy.value
          .contains(servicioProducto);
    }
    return controller.serviciosProductosPagar.value.contains(servicioProducto);
  }
}
