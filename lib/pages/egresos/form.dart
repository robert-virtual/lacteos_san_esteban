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
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (text) {
                controller.servicioProductoPagar.value =
                    text ?? controller.serviciosProductosPagarCopy.value[0];
              },
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.servicioProductoPagar.value != "Préstamo",
              child: Row(
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
                      DropdownButton<String>(
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
                        onChanged: controller.setUnidad,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          const Text("Proveedor"),
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
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
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
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (proveedor.text.trim().isEmpty) {
                          proveedor.text = "";
                          return;
                        }
                        if (controller.proveedoresCopy
                            .contains(proveedor.text.trim())) {
                          Get.back();
                          controller.proveedor.value = proveedor.text.trim();
                          return;
                        }
                        controller.proveedoresCopy.value = [
                          ...controller.proveedoresCopy.value,
                          proveedor.text.trim()
                        ];
                        controller.proveedor.value = proveedor.text.trim();

                        if (Get.context != null) {
                          Navigator.pop(Get.context!);
                        }
                      },
                      child: const Text("Guardar"),
                    )
                  ],
                ),
              );
            },
            child: const Text("Agregar Proveedor"),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Text("Registrado por ${controller.userName.value}"),
          ),
          const SizedBox(height: 20),
          Text("Fecha: ${f.format(DateTime.now())}"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () async {
          if (checkData()) {
            Get.dialog(
              AlertDialog(
                title: const Text("Falta informacion"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [Text("Debes llenar todos los campos")],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
            return;
          }
          String res = await Get.showOverlay(
            loadingWidget: const Center(child: CircularProgressIndicator()),
            asyncFunction: () async {
              //guardar cuenta por pagar
              final cantidad_ = cantidad.text.isEmpty
                  ? ""
                  : controller.servicioProductoPagar.value == "Préstamo"
                      ? 1
                      : cantidad.text;
              final unidad_ = cantidad.text.isEmpty
                  ? ""
                  : controller.servicioProductoPagar.value == "Préstamo"
                      ? ""
                      : controller.unidad.value;
              String res = await controller.sendSheet(
                "CuentasPorPagar!A:G",
                [
                  controller.userName.value,
                  f2.format(DateTime.now()),
                  controller.servicioProductoPagar.value,
                  cantidad_,
                  unidad_,
                  controller.proveedor.value,
                  monto.text
                ],
              );
              // guardar nuevo proveedor en caso de estar vacio no se gurdara
              if (proveedor.text.isNotEmpty) {
                await controller.sendSheet(
                  "Metadata!D${controller.proveedoresCopy.value.length + 1}",
                  [proveedor.text.trim()],
                );
              }
              return res;
            },
          );
          Get.back();
          Get.snackbar("Guardar Datos", res);
        },
      ),
    );
  }

  bool checkData() {
    return monto.text.isEmpty ||
        (controller.servicioProductoPagar.value != "Préstamo" &&
            cantidad.text.isEmpty);
  }
}
