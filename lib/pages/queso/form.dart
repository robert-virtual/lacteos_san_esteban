import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class QuesoForm extends GetView<UserController> {
  QuesoForm({Key? key}) : super(key: key);
  final f2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  final lecheEntera = TextEditingController();
  final lecheDescremada = TextEditingController();
  final sal = TextEditingController();
  final cuajo = TextEditingController();
  final sueroParaCuajar = TextEditingController();
  final chileJalapeno = TextEditingController();
  final chileBolson = TextEditingController();
  final libras = TextEditingController();
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
            "Registrar producción de queso",
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
            controller: lecheDescremada,
            decoration: const InputDecoration(
              label: Text(
                "Leche descremada usada (Litros)",
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            controller: sal,
            decoration: const InputDecoration(
              label: Text(
                "Sal Usada (gramos)",
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            controller: cuajo,
            decoration: const InputDecoration(
              label: Text(
                "Cuajo Usado (bolsitas)",
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            controller: sueroParaCuajar,
            decoration: const InputDecoration(
              label: Text(
                "Suero para Cuajar (Litros)",
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Tipo de Queso"),
          Obx(() => DropdownButton<String>(
              value: controller.tipoQueso.value,
              items: controller.productosCobrarCopy
                  .where((prod) => prod.startsWith("Queso"))
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: controller.setQueso)),
          Obx(
            () => Visibility(
                visible: controller.tipoQueso.value == "Queso Con Chile",
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: chileJalapeno,
                      decoration: const InputDecoration(
                        label: Text(
                          "Chile Jalapeño (Unidades)",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: chileBolson,
                      decoration: const InputDecoration(
                        label: Text(
                          "Chile bolsón verde rojo y amarillo (Unidades)",
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 20),
          Obx(() => Text("Registrado por ${controller.userName.value}")),
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
          final res = await Get.showOverlay(
            loadingWidget: const Center(child: CircularProgressIndicator()),
            asyncFunction: () async => await controller.sendSheet(
              "Queso!A:K",
              [
                controller.userName.value,
                f2.format(DateTime.now()),
                libras.text,
                controller.tipoQueso.value,
                lecheEntera.text,
                lecheDescremada.text,
                sal.text,
                cuajo.text,
                sueroParaCuajar.text,
                chileJalapeno.text,
                chileBolson.text,
              ],
            ),
          );
          Get.back();
          Get.snackbar("Guardar Datos", res);
        },
      ),
    );
  }

  bool checkData() {
    return libras.text.isEmpty ||
        lecheEntera.text.isEmpty ||
        lecheDescremada.text.isEmpty ||
        sal.text.isEmpty ||
        cuajo.text.isEmpty ||
        sueroParaCuajar.text.isEmpty ||
        (controller.tipoQueso.value == "Queso Con Chile" &&
            chileJalapeno.text.isEmpty) ||
        (controller.tipoQueso.value == "Queso Con Chile" &&
            chileBolson.text.isEmpty);
  }
}
