import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';
import 'package:lateos_san_esteban/pages/form_leche.dart';

class Leche extends GetView<UserController> {
  Leche({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leche")),
      body: FutureBuilder<List<ILeche>>(
          future: controller.getLecheSheet(),
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return const Center(
                child: Text("Ha ocurrido un error al cargar la informacion"),
              );
            }
            if (snap.isBlank == true) {
              return const Center(child: Text("No hay datos que mostrar"));
            }
            return ListView.builder(
                itemCount: snap.data!.length,
                itemBuilder: (ctx, idx) {
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                                "${snap.data![idx].litros} lts | Recibidos por ${snap.data![idx].recibidoPor}"),
                            subtitle: Text(
                                "Proveedor ${snap.data![idx].proveedor} | Fecha ${snap.data![idx].fecha}"),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
