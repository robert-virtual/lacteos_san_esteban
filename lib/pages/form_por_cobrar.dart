import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class PorCobrarForm extends GetView<UserController> {
  PorCobrarForm({Key? key}) : super(key: key);
  final monto = TextEditingController();
  final cantidad = TextEditingController();
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final f2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  final cliente = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Cuentas por Cobrar")),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 20),
            const Text(
              "Agregar Cuentas Por Cobrar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20),
            const Text(
              "Producto",
            ),
            Obx(
              () => DropdownButton<String>(
                  value: controller.productoCobrar.value,
                  items: controller.productosCobrarCopy.value
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (text) {
                    controller.productoCobrar.value =
                        text ?? controller.productosCobrarCopy.value[0];
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
                        "Cantidad (Litros)",
                      ),
                    ),
                  ),
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
            const SizedBox(height: 20),
            const Text("Cliente"),
            Obx(
              () => DropdownButton<String>(
                  value: controller.cliente.value,
                  items: controller.clientesCopy.value
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (text) {
                    controller.cliente.value =
                        text ?? controller.clientesCopy[0];
                  }),
            ),
            ElevatedButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  title: const Text("Agregar Cliente"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: cliente,
                        decoration: const InputDecoration(
                          label: Text("Nombre de Cliente"),
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
                          controller.clientesCopy.value = [
                            ...controller.clientesCopy.value,
                            cliente.text
                          ];
                          controller.cliente.value = cliente.text;
                          if (Get.context != null) {
                            Navigator.pop(Get.context!);
                          }
                        },
                        child: const Text("Guardar"))
                  ],
                ));
              },
              child: const Text("Agregar Cliente"),
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
                  //guardar cuenta por cobrar 
                  await controller.sendSheet(
                    "CuentasPorCobrar!A:G",
                    [
                      controller.account!.displayName,
                      f2.format(DateTime.now()),
                      controller.productoCobrar.value,
                      double.parse(cantidad.text),
                      controller.cliente.value,
                      double.parse(monto.text)
                    ],
                  );
                  // guardar proveedor
                  await controller.sendSheet(
                      "Metadata!E${controller.clientesCopy.value.length + 1}",
                      [cliente.text]);
                },
              );
              Get.back();
              Get.snackbar("Guardar Datos", res);
            }));
  }

  bool checkInputs() {
    if (controller.cliente.value.isEmpty) {
      Get.snackbar(
          "No Se Puede Guardar Registro", "Debes Ingresar Un Proveedor");
      return true;
    }
    return false;
  }
}
