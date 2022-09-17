import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class QuesoForm extends GetView<UserController> {
  QuesoForm({Key? key}) : super(key: key);
  final litros = TextEditingController();
  final libras = TextEditingController();
  List<String> quesos = [
    "Queso semi seco",
    "Queso crema",
    "Queso fresco",
    "Queso con chile",
    "Queso frijolero",
  ];
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Registrar Queso")),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 20),
            const Text(
              "Registrar produccion de queso",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: litros,
              decoration: const InputDecoration(
                label: Text(
                  "Litros de leche usados",
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: libras,
              decoration: const InputDecoration(
                label: Text(
                  "Libras Producidas",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => DropdownButton<String>(
                hint: const Text("Tipo de Queso"),
                value: controller.tipoQueso.value,
                items: quesos
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: controller.setQueso)),
            const SizedBox(height: 20),
            GetBuilder<UserController>(
                builder: (_) =>
                    Text("Registrado por ${controller.account!.displayName}")),
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
                      await controller.sendSheet("Queso!A:E", [
                        litros.text,
                        libras.text,
                        controller.tipoQueso.value,
                        controller.account!.displayName,
                        f.format(DateTime.now())
                      ]));
              Get.back();
              Get.snackbar("Guardar Datos", res);
            }));
  }
}
