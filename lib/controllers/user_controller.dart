import 'dart:convert';

import 'package:flutter_launcher_icons/utils.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';

enum MajorDimension { COLUMNS, ROWS }

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}

class UserController extends GetxController {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    "https://www.googleapis.com/auth/spreadsheets",
  ]);
  final spreadsheetId = "1hlcv__-71at852uml7TOKA_AS90qlkOQvcHOk-yq1bQ";
  final baseUrl = "https://sheets.googleapis.com/v4/spreadsheets/";
  var tipoQueso = "Queso semi seco".obs;
  var fechaFiltro = DateTime.now().obs;
  var unidad = "".obs;
  var unidades = [""].obs;

  var proveedor = "".obs;
  var proveedores = [""].obs;

  var cliente = "".obs;
  var clientes = [""].obs;

  var searching = false.obs;
  var search = "".obs;

  var servicioProductoPagar = "".obs;
  var serviciosProductosPagar = [].obs;
  var serviciosProductosPagarCopy = [""].obs;

  var servicioProductoCobrar = "".obs;
  var serviciosProductosCobrar = [].obs;
  var serviciosProductosCobrarCopy = [""].obs;

  var searchSelectedaArg = "".obs;
  GoogleSignInAccount? account;

  @override
  void onInit() {
    super.onInit();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? _account) {
      account = _account;
      update();
      loadMetadata();
    });
    googleSignIn.signInSilently().then((account_) {
      update();
      if (account_ != null) {
        Get.toNamed("/home");
        loadMetadata();
      }
    });
  }

  Future<List<List>> getSheet(
    String sheetAndRange, {
    String spread = "1hlcv__-71at852uml7TOKA_AS90qlkOQvcHOk-yq1bQ",
    MajorDimension majorDimension = MajorDimension.ROWS,
    reversed = true,
    removeFisrt = true,
  }) async {
    final http.Response res = await http.get(
        Uri.parse(
            '$baseUrl$spread/values/$sheetAndRange?majorDimension=${majorDimension.name}'),
        headers: await account!.authHeaders);
    if (res.statusCode != 200) {
      print(prettifyJsonEncode(jsonDecode(res.body)));
      return List.empty();
    }
    final Map<String, dynamic> data =
        json.decode(res.body) as Map<String, dynamic>;
    List<List> lista = List.from(data["values"]);
    if (removeFisrt) {
      lista.removeAt(0);
    }

    if (reversed) return lista.reversed.toList();
    return lista.toList();
  }

  Future<String> sendSheet(String sheetAndRange, List values,
      [String spread = "1hlcv__-71at852uml7TOKA_AS90qlkOQvcHOk-yq1bQ"]) async {
    final http.Response res = await http.post(
        Uri.parse(
            '$baseUrl$spread/values/$sheetAndRange:append?valueInputOption=USER_ENTERED'),
        headers: await account!.authHeaders,
        body: jsonEncode({
          "values": [values]
        }));
    if (res.statusCode != 200) {
      print(res.body);
      return "Hubo un error al guardar los datos (${res.statusCode})";
    }
    return "Datos guardados con exito";
  }

  void setQueso(String? queso) {
    tipoQueso.value = queso ?? "Queso semi seco";
  }

  void setUnidad(String? unidad_) {
    unidad.value = unidad_ ?? unidades.value[0];
  }

  Future<void> loadMetadata() async {
    final data = await getSheet("Metadata!A:E",
        majorDimension: MajorDimension.COLUMNS,
        reversed: false,
        removeFisrt: false);
    serviciosProductosPagarCopy.value = data[0].sublist(1).cast();
    unidades.value = data[1].sublist(1).cast();
    serviciosProductosCobrarCopy.value = data[2].sublist(1).cast();
    proveedores.value = data[3].sublist(1).cast();
    clientes.value = data[4].sublist(1).cast();

    servicioProductoPagar.value = serviciosProductosPagarCopy.value[0];
    unidad.value = unidades.value[0];
    proveedor.value = proveedores.value[0];
  }
}
