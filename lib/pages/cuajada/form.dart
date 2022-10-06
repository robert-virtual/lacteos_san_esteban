import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';

class CuajadaForm extends GetView<UserController> {
  CuajadaForm({Key? key}) : super(key: key);
  final f2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  final lecheEntera = TextEditingController();
  final lecheDescremada = TextEditingController();
  final sal = TextEditingController();
  final cuajo = TextEditingController();
  final sueroParaCuajar = TextEditingController();
  final libras = TextEditingController();
  final f = DateFormat("dd/MM/yyyy hh:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Cuajada")),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 20),
          const Text(
            "Registrar produccion de Cuajada",
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
          Obx(() => Text("Registrado por ${controller.userName.value}")),
          const SizedBox(height: 20),
          Text("Fecha: ${f.format(DateTime.now())}"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () async {
          final res = await Get.showOverlay(
              loadingWidget: const Center(child: CircularProgressIndicator()),
              asyncFunction: () async {
                final data = [
                  controller.userName.value,
                  f2.format(DateTime.now()),
                  libras.text,
                  lecheEntera.text,
                  lecheDescremada.text,
                  sal.text,
                  cuajo.text,
                  sueroParaCuajar.text,
                ];
                await controller.sendSheet("Cuajada!A:H", data);

              });
          Get.back();
          Get.snackbar("Guardar Datos", res);
        },
      ),
    );
  }
}
