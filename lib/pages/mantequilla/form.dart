import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class MantequillaForm extends GetView<UserController> {
  MantequillaForm({Key? key}) : super(key: key);
  final f2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  final lecheEntera = TextEditingController();
  final sal = TextEditingController();
  final mantequillaCrema = TextEditingController();
  final cremaIndustrial = TextEditingController();
  final libras = TextEditingController();
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Registrar Mantequilla")),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 20),
            const Text(
              "Registrar produccion de Mantequilla",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
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
            TextField(
              keyboardType: TextInputType.number,
              controller: lecheEntera,
              decoration: const InputDecoration(
                label: Text(
                  "Leche entera usada (Litros)",
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: mantequillaCrema,
              decoration: const InputDecoration(
                label: Text(
                  "Mantequilla Creama (Libras)",
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: cremaIndustrial,
              decoration: const InputDecoration(
                label: Text(
                  "Crema Industrial (Libras)",
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Tipo de Mantequilla"),
            Obx(
              () => DropdownButton<String>(
                  value: controller.tipoMantequilla.value,
                  items: controller.productosCobrarCopy
                      .where((prod) => prod.startsWith("Mantequilla"))
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (text) {
                    if (text != null) controller.tipoMantequilla.value = text;
                  }),
            ),
            Obx(
              () => Visibility(
                  visible: controller.tipoMantequilla.value != "Mantequilla Crema Sin Sal",
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: sal,
                    decoration: const InputDecoration(
                      label: Text(
                        "Sal Usada (gramos)",
                      ),
                    ),
                  )),
            ),
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
                      await controller.sendSheet("Mantequilla!A:H", [
                        controller.account!.displayName,
                        f2.format(DateTime.now()),
                        libras.text,
                        controller.tipoMantequilla.value,
                        lecheEntera.text,
                         controller.tipoMantequilla.value.contains("Sin")
                         ? 0:sal.text,
                        mantequillaCrema.text,
                        cremaIndustrial.text,
                      ]));
              Get.back();
              Get.snackbar("Guardar Datos", res);
            }));
  }
}
