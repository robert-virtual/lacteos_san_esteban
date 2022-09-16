import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';
import 'package:lateos_san_esteban/pages/crema.dart';
import 'package:lateos_san_esteban/pages/cuajada.dart';
import 'package:lateos_san_esteban/pages/form_leche.dart';
import 'package:lateos_san_esteban/pages/home.dart';
import 'package:lateos_san_esteban/pages/leche.dart';
import 'package:lateos_san_esteban/pages/login.dart';
import 'package:lateos_san_esteban/pages/mantequilla.dart';
import 'package:lateos_san_esteban/pages/quesillo.dart';
import 'package:lateos_san_esteban/pages/queso.dart';
import 'package:lateos_san_esteban/pages/requeson.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/login",
    getPages: [
      GetPage(
          name: "/login", page: () => const Login(), binding: UserBinding()),
      GetPage(name: "/home", page: () => const Home(), binding: UserBinding()),
      GetPage(name: "/leche", page: () => Leche(), binding: UserBinding()),
      GetPage(
          name: "/leche_form", page: () => LecheForm(), binding: UserBinding()),
      GetPage(
          name: "/queso", page: () => const Queso(), binding: UserBinding()),
      GetPage(
          name: "/cuajada",
          page: () => const Cuajada(),
          binding: UserBinding()),
      GetPage(
          name: "/quesillo",
          page: () => const Quesillo(),
          binding: UserBinding()),
      GetPage(
          name: "/crema", page: () => const Crema(), binding: UserBinding()),
      GetPage(
          name: "/mantequilla",
          page: () => const Mantequilla(),
          binding: UserBinding()),
      GetPage(
          name: "/requeson",
          page: () => const Requeson(),
          binding: UserBinding()),
    ],
  ));
}
