import 'dart:convert';

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
  final spreadsheetId =
      const String.fromEnvironment("ENV", defaultValue: "DEVELOPMENT") ==
              "PRODUCTION"
          ? "1hlcv__-71at852uml7TOKA_AS90qlkOQvcHOk-yq1bQ"
          : "1VXOWrnURGrABxnMOxkYw_nmZpX-uInBXBbh1lPPpp2I";
  final baseUrl = "https://sheets.googleapis.com/v4/spreadsheets/";
  var userName = "".obs;
  var tipoQueso = "".obs;
  var tipoQuesillo = "".obs;
  var tipoMantequilla = "".obs;

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
  var loading = true.obs;
  @override
  void onInit() {
    super.onInit();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? _account) {
      account = _account;
      update();
      loadMetadata();
      loading.value = false;
    });
    googleSignIn.signInSilently().then((account_) {
      update();
      loading.value = false;
      if (account_ != null) {
        Get.toNamed("/home");
        loadMetadata();
      }
    });
  }

  Future<List<List>> getSheet(
    String sheetAndRange, {
    String? spread,
    MajorDimension majorDimension = MajorDimension.ROWS,
    reversed = true,
    removeFisrt = true,
  }) async {
    if (account == null) {
      return List.empty();
    }
    final http.Response res = await http.get(
        Uri.parse(
            '$baseUrl${spread ?? spreadsheetId}/values/$sheetAndRange?majorDimension=${majorDimension.name}'),
        headers: await account!.authHeaders);
    if (res.statusCode != 200) {
      print(jsonDecode(res.body));
      throw Exception(
          "Ups algo ha salido mal, vuelve a intentar más tarde. Error: ${res.statusCode}");
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
      [String? spread]) async {
    final http.Response res = await http.post(
        Uri.parse(
            '$baseUrl${spread ?? spreadsheetId}/values/$sheetAndRange:append?valueInputOption=USER_ENTERED'),
        headers: await account!.authHeaders,
        body: jsonEncode({
          "values": [values]
        }));
    if (res.statusCode != 200) {
      print(res.body);
      throw Exception("Hubo un error al guardar los datos (${res.statusCode})");
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
    if (data.isEmpty) {
      return;
    }
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
    tipoMantequilla.value = productosCobrarCopy.value
        .where((e) => e.startsWith("Mantequilla"))
        .first;
    tipoQuesillo.value =
        productosCobrarCopy.value.where((e) => e.startsWith("Quesillo")).first;

    proveedor.value = proveedoresCopy.value.first;
    cliente.value = clientesCopy.value.first;
    registradoPor.value = registradoresCopy.value.first;
    final idx = account!.email.indexOf("@");
    userName.value = account!.displayName ?? account!.email.substring(0, idx);
    if (registradoresCopy.isNotEmpty &&
        !registradoresCopy.contains(userName.value)) {
      await sendSheet("Metadata!F${registradoresCopy.length + 2}", [userName]);
      final lista = await getSheet("Metadata!F:F",
          removeFisrt: false,
          reversed: false,
          majorDimension: MajorDimension.COLUMNS);
      lista[0].removeAt(0);
      registradoresCopy.value = lista[0].cast();
    }
  }
}
