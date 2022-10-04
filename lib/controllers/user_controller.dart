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

  var tipoQueso = "".obs;
  var tiposQueso = List<String>.empty().obs;
  var tiposQuesoCopy = [""].obs;

  var monto = 0.0.obs;
  var montoCobrar = 0.0.obs;
  var cantidadCobrar = 0.obs;
  var fechaFiltro = DateTime.now().obs;

  var unidad = "".obs;
  var unidades = List<String>.empty().obs;
  var unidadesCopy = [""].obs;

  var proveedor = "".obs;
  var proveedores = List<String>.empty().obs;
  var proveedoresCopy = [""].obs;

  var cliente = "".obs;
  var clientes = List<String>.empty().obs;
  var clientesCopy = [""].obs;

  var registradoPor = "".obs;
  var registradores = List<String>.empty().obs;
  var registradoresCopy = [""].obs;

  var servicioProductoPagar = "".obs;
  var serviciosProductosPagar = List<String>.empty().obs;
  var serviciosProductosPagarCopy = [""].obs;

  var productoCobrar = "".obs;
  var productosCobrar = List<String>.empty().obs;
  var productosCobrarCopy = [""].obs;

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
    unidad.value = unidad_ ?? unidadesCopy.value[0];
  }

  Future<void> loadMetadata() async {
    final data = await getSheet("Metadata!A:F",
        majorDimension: MajorDimension.COLUMNS,
        reversed: false,
        removeFisrt: false);
    serviciosProductosPagarCopy.value = data[0].sublist(1).cast();
    unidadesCopy.value = data[1].sublist(1).cast();
    productosCobrarCopy.value = data[2].sublist(1).cast();
    proveedoresCopy.value = data[3].sublist(1).cast();
    clientesCopy.value = data[4].sublist(1).cast();
    registradoresCopy.value = data[5].sublist(1).cast();

    servicioProductoPagar.value = serviciosProductosPagarCopy.value[0];
    productoCobrar.value = productosCobrarCopy.value[0];

    unidad.value = unidadesCopy.value[0];
    tipoQueso.value =
        productosCobrarCopy.value.where((e) => e.startsWith("Queso")).first;
    proveedor.value = proveedoresCopy.value[0];
    cliente.value = clientesCopy.value[0];
    registradoPor.value = registradoresCopy.value[0];
  }
}
