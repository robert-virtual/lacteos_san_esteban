import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class PorPagarForm extends GetView<UserController> {
  PorPagarForm({Key? key}) : super(key: key);
  final monto = TextEditingController();
  final cantidad = TextEditingController();
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final f2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  final proveedor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Cuentas por Pagar")),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 20),
            const Text(
              "Agregar Cuentas por Pagar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20),
            const Text(
              "Servicio/Producto",
            ),
            Obx(
              () => DropdownButton<String>(
                  value: controller.servicioProductoPagar.value,
                  items: controller.serviciosProductosPagarCopy.value
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (text) {
                    controller.servicioProductoPagar.value =
                        text ?? controller.serviciosProductosPagarCopy.value[0];
                  }),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: cantidad,
                    decoration: const InputDecoration(
                      label: Text(
                        "Cantidad",
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text("Unidad de medida"),
                    Obx(
                      () => DropdownButton<String>(
                          underline: null,
                          value: controller.unidad.value,
                          items: controller.unidades.value
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: controller.setUnidad),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: monto,
              decoration: const InputDecoration(
                label: Text(
                  "Monto (Lps)",
                ),
              ),
            ),
            FutureBuilder<List<List>>(
                future: controller.getSheet("Metadata!D:D"),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("Ha ocurrido un error al cargar la informacion"),
                      ],
                    );
                  }
                  if (snap.data!.isEmpty) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("No hay proveedores"),
                      ],
                    );
                  }
                  controller.unidad.value = snap.data![0][0];
                  return Obx(
                    () => DropdownButton<String>(
                        value: controller.proveedor.value,
                        items: snap.data!
                            .map(
                              (e) => DropdownMenuItem(
                                value: e[0] as String,
                                child: Text(e[0]),
                              ),
                            )
                            .toList(),
                        onChanged: (text) {
                          controller.proveedor.value = text ?? "";
                        }),
                  );
                }),
            ElevatedButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("Hola"),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () async {
                          final res =
                              await Get.showOverlay(asyncFunction: () async {
                            controller.sendSheet(
                                "Metadata!D:D", [controller.proveedor.value]);
                            controller.proveedores.value =
                                (await controller.getSheet("Metadata!D:D"))
                                    .map((e) => e[0] as String)
                                    .toList();
                          });
                          if (Get.context != null) {
                            Navigator.pop(Get.context!);
                          }
                        },
                        child: const Text("Guadar"))
                  ],
                ));
              },
              child: const Text("Agregar Proveedor"),
            ),
            const SizedBox(height: 20),
            GetBuilder<UserController>(
              builder: (_) =>
                  Text("Registrado por ${controller.account!.displayName}"),
            ),
            const SizedBox(height: 20),
            Text("Fecha: ${f.format(DateTime.now())}"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.send),
            onPressed: () async {
              if (checkInputs()) {
                return;
              }
              final res = await Get.showOverlay(
                  loadingWidget:
                      const Center(child: CircularProgressIndicator()),
                  asyncFunction: () async =>
                      await controller.sendSheet("CuentasPorPagar!A:G", [
                        controller.account!.displayName,
                        f2.format(DateTime.now()),
                        controller.servicioProductoPagar.value,
                        cantidad.text.isEmpty
                            ? ""
                            : double.parse(cantidad.text),
                        cantidad.text.isEmpty ? "" : controller.unidad.value,
                        proveedor.text,
                        double.parse(monto.text)
                      ]));
              Get.back();
              Get.snackbar("Guardar Datos", res);
            }));
  }

  bool checkInputs() {
    if (controller.proveedor.value.isEmpty) {
      Get.snackbar(
          "No Se Puede Guardar Registro", "Debes Ingresar Un Proveedor");
      return true;
    }
    return false;
  }
}
