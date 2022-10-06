import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';
import 'package:lateos_san_esteban/pages/cuajada/form.dart';
import 'package:lateos_san_esteban/pages/cuajada/index.dart';

//ingresos
import 'package:lateos_san_esteban/pages/ingresos/form.dart';
import 'package:lateos_san_esteban/pages/ingresos/index.dart';
//egresos
import 'package:lateos_san_esteban/pages/egresos/index.dart';
import 'package:lateos_san_esteban/pages/egresos/form.dart';
import 'package:lateos_san_esteban/pages/mantequilla/form.dart';
import 'package:lateos_san_esteban/pages/quesillo/form.dart';

import 'package:lateos_san_esteban/pages/queso/form.dart';
import 'package:lateos_san_esteban/pages/home.dart';
import 'package:lateos_san_esteban/pages/login.dart';
import 'package:lateos_san_esteban/pages/mantequilla/index.dart';
import 'package:lateos_san_esteban/pages/quesillo/index.dart';
import 'package:lateos_san_esteban/pages/queso/index.dart';
import 'package:lateos_san_esteban/pages/requeson/form.dart';
import 'package:lateos_san_esteban/pages/requeson/index.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/login",
    theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
    getPages: [
      GetPage(
          name: "/login", page: () => const Login(), binding: UserBinding()),
      GetPage(name: "/home", page: () => const Home(), binding: UserBinding()),
      GetPage(name: "/queso", page: () => Queso(), binding: UserBinding()),
      GetPage(
          name: "/queso_form", page: () => QuesoForm(), binding: UserBinding()),
      GetPage(
          name: "/cuajada",
          page: () =>  Cuajada(),
          binding: UserBinding()),
      GetPage(
          name: "/cuajada_form", page: () => CuajadaForm(), binding: UserBinding()),
      GetPage(
          name: "/quesillo",
          page: () =>  Quesillo(),
          binding: UserBinding()),
      GetPage(
          name: "/quesillo_form", page: () => QuesilloForm(), binding: UserBinding()),
      GetPage(
          name: "/mantequilla",
          page: () =>  Mantequilla(),
          binding: UserBinding()),
      GetPage(
          name: "/mantequilla_form", page: () => MantequillaForm(), binding: UserBinding()),
      GetPage(
          name: "/requeson",
          page: () =>  Requeson(),
          binding: UserBinding()),
      GetPage(
          name: "/requeson_form", page: () => RequesonForm(), binding: UserBinding()),
      GetPage(
          name: "/egresos", page: () => PorPagar(), binding: UserBinding()),
      GetPage(
          name: "/egresos_form",
          page: () => PorPagarForm(),
          binding: UserBinding()),
      GetPage(
          name: "/ingresos", page: () => PorCobrar(), binding: UserBinding()),
      GetPage(
          name: "/ingresos_form",
          page: () => PorCobrarForm(),
          binding: UserBinding()),
    ],
  ));
}
