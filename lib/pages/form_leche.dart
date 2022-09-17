import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class LecheForm extends GetView<UserController> {
  LecheForm({Key? key}) : super(key: key);
  final litros = TextEditingController();
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  final proveedor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Agregar Leche")),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 20),
            const Text(
              "Registrar ingreso de leche",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: litros,
              decoration: const InputDecoration(
                label: Text(
                  "Litros de leche",
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
                    Text("Recibido por ${controller.account!.displayName}")),
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
                      await controller.sendSheet("Leche!A:D", [
                        litros.text,
                        controller.account!.displayName,
                        proveedor.text,
                        f.format(DateTime.now())
                      ]));
              Get.back();
              Get.snackbar("Guardar Datos", res);
            }));
  }
}