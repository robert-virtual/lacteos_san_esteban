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
                          items: controller.unidadesCopy.value
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
            Obx(
              () => DropdownButton<String>(
                  value: controller.proveedor.value,
                  items: controller.proveedoresCopy.value
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (text) {
                    controller.proveedor.value =
                        text ?? controller.proveedoresCopy[0];
                  }),
            ),
            ElevatedButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  title: const Text("Agregar Proveedor"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: proveedor,
                        decoration: const InputDecoration(
                          label: Text("Nombre de Proveedor"),
                        ),
                      )
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
                          controller.proveedoresCopy.value = [
                            ...controller.proveedoresCopy.value,
                            proveedor.text
                          ];
                          controller.proveedor.value = proveedor.text;
                          if (Get.context != null) {
                            Navigator.pop(Get.context!);
                          }
                        },
                        child: const Text("Guardar"))
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
                loadingWidget: const Center(child: CircularProgressIndicator()),
                asyncFunction: () async {
                  //guadra cuenta por pagar
                  await controller.sendSheet(
                    "CuentasPorPagar!A:G",
                    [
                      controller.account!.displayName,
                      f2.format(DateTime.now()),
                      controller.servicioProductoPagar.value,
                      cantidad.text.isEmpty ? "" : double.parse(cantidad.text),
                      cantidad.text.isEmpty ? "" : controller.unidad.value,
                      controller.proveedor.value,
                      double.parse(monto.text)
                    ],
                  );
                  // guardar proveedor
                  await controller.sendSheet(
                      "Metadata!D${controller.proveedoresCopy.value.length + 1}",
                      [proveedor.text]);
                },
              );
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
