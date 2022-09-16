import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lateos_san_esteban/controllers/user_controller.dart';
import 'package:lateos_san_esteban/pages/home.dart';
import 'package:lateos_san_esteban/pages/login.dart';
import 'package:lateos_san_esteban/pages/queso.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/login",
    getPages: [
      GetPage(
          name: "/login", page: () => const Login(), binding: UserBinding()),
      GetPage(name: "/home", page: () => const Home(), binding: UserBinding()),
      GetPage(
          name: "/queso", page: () => const Queso(), binding: UserBinding()),
    ],
  ));
}
