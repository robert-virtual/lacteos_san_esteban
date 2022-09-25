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
        appBar: AppBar(title: const Text("Cuentas por pagar")),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 20),
            const Text(
              "Agregar Cuentas por pagar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: servicioProducto,
              decoration: const InputDecoration(
                label: Text(
                  "Servicio o Producto",
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: cantidad,
              decoration: InputDecoration(
                label: const Text(
                  "Cantidad",
                ),
                suffix: Obx(() => DropdownButton<String>(
                    underline: null,
                    hint: const Text("Unidad de medida"),
                    value: controller.unidad.value,
                    items: unidades
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: controller.setUnidad)),
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
                      await controller.sendSheet("CuentasPorCobrar!A:G", [
                        controller.account!.displayName,
                        f2.format(DateTime.now()),
                        servicioProducto.text,
                        double.parse(cantidad.text),
                        controller.unidad.value,
                        proveedor.text,
                        double.parse(monto.text)
                      ]));
              Get.back();
              Get.snackbar("Guardar Datos", res);
            }));
  }
}
