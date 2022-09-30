import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class PorPagarForm extends GetView<UserController> {
  PorPagarForm({Key? key}) : super(key: key);
  final servicioProducto = TextEditingController();
  final monto = TextEditingController();
  final cantidad = TextEditingController();
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final f2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  final proveedor = TextEditingController();
  final unidades = [
    "litros",
    "libras",
    "gramos",
    "bolsitas",
    "unidades",
    "horas",
    "dias",
    ""
  ];
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
            FutureBuilder<List<List>>(
                future: controller.getSheet("Metadata!A:A"),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return const Text(
                        "Ha ocurrido un error al cargar la informacion");
                  }
                  if (snap.isBlank == true) {
                    return const Text("No hay datos que mostrar");
                  }
                  controller.servicioProductoPagar.value = snap.data![0][0];
                  return Obx(
                    () => DropdownButton<String>(
                        value: controller.servicioProductoPagar.value,
                        items: snap.data!
                            .map((e) => DropdownMenuItem(
                                value: e[0] as String, child: Text(e[0])))
                            .toList(),
                        onChanged: (text) {
                          controller.servicioProductoPagar.value =
                              text ?? snap.data![0][0];
                        }),
                  );
                }),
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
                    FutureBuilder<List<List>>(
                        future: controller.getSheet("Metadata!B:B"),
                        builder: (ctx, snap) {
                          if (!snap.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snap.hasError) {
                            return const Text(
                                "Ha ocurrido un error al cargar la informacion");
                          }
                          if (snap.isBlank == true) {
                            return const Text("No hay datos que mostrar");
                          }
                          controller.unidad.value = snap.data![0][0];
                          return Obx(
                            () => DropdownButton<String>(
                                underline: null,
                                value: controller.unidad.value,
                                items: snap.data!
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e[0] as String,
                                        child: Text(e[0]),
                                      ),
                                    )
                                    .toList(),
                                onChanged: controller.setUnidad),
                          );
                        }),
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
            TextField(
              controller: proveedor,
              decoration: const InputDecoration(
                label: Text(
                  "Proveedor",
                ),
              ),
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
              final res = await Get.showOverlay(
                  loadingWidget:
                      const Center(child: CircularProgressIndicator()),
                  asyncFunction: () async =>
                      await controller.sendSheet("CuentasPorPagar!A:G", [
                        controller.account!.displayName,
                        f2.format(DateTime.now()),
                        servicioProducto.text,
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
}
