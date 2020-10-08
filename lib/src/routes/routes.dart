import 'package:sisinfo/src/pages/formulario_page.dart';

import 'package:flutter/material.dart';
import 'package:sisinfo/src/pages/home_page.dart';
import 'package:sisinfo/src/pages/historial_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    FormularioPage.route: (context) => FormularioPage(),
    Homepage.route: (context) => Homepage(),
    HistorialPage.route: (context) => HistorialPage(),
  };
}
