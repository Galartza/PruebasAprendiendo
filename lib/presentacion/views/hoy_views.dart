import 'package:flutter/material.dart';

void main() {
  runApp(HoyViews());
}

class Actividad {
  String nombre;
  DateTime fecha;

  Actividad({required this.nombre, required this.fecha});
}

class HoyViews extends StatefulWidget {
  @override
  _HoyViewsState createState() => _HoyViewsState();
}

class _HoyViewsState extends State<HoyViews> {
  List<Actividad> actividades = [
    Actividad(nombre: 'Actividad 1', fecha: DateTime(2024, 2, 5)),
    Actividad(nombre: 'Actividad 2', fecha: DateTime(2024, 2, 5)),
    // Agrega más actividades según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    List<Actividad> actividadesDeHoy = obtenerActividadesDeHoy();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HoyViews'),
        ),
        body: ListView.builder(
          itemCount: actividadesDeHoy.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(actividadesDeHoy[index].nombre),
              // Puedes agregar más detalles aquí según tus necesidades
            );
          },
        ),
      ),
    );
  }

  List<Actividad> obtenerActividadesDeHoy() {
    DateTime fechaActual = DateTime.now();
    return actividades.where((actividad) => actividad.fecha.day == fechaActual.day && actividad.fecha.month == fechaActual.month && actividad.fecha.year == fechaActual.year).toList();
  }
}
