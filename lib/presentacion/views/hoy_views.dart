import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: HoyViews(),
  ));
}

class Actividad {
  final String nombre;
  final DateTime fecha;

  Actividad({required this.nombre, required this.fecha});

  // Método para convertir la actividad a un mapa para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fecha': fecha.millisecondsSinceEpoch,
    };
  }

  // Método para crear una actividad desde un mapa recuperado del almacenamiento
  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      nombre: map['nombre'],
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha']),
    );
  }
}

class HoyViews extends StatefulWidget {
  @override
  _HoyViewsState createState() => _HoyViewsState();
}

class _HoyViewsState extends State<HoyViews> {
  late DateTime _selectedDay;
  late Map<DateTime, List<Actividad>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _events = {};
    _loadActividadesFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoy'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.month,
            onFormatChanged: (format) {},
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _events[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_events[_selectedDay]?[index].nombre ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Cargar actividades desde Shared Preferences
  Future<void> _loadActividadesFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? actividadesJson = prefs.getStringList('actividades');
    if (actividadesJson != null) {
      List<Actividad> actividades =
          actividadesJson.map((json) => Actividad.fromMap(jsonDecode(json))).toList();
      setState(() {
        _events = _groupActividades(actividades);
      });
    }
  }

  // Agrupar actividades por fecha
  Map<DateTime, List<Actividad>> _groupActividades(List<Actividad> logros) {
    Map<DateTime, List<Actividad>> events = {};
    for (var logro in logros) {
      DateTime fecha = logro.fecha;
      if (events.containsKey(fecha)) {
        events[fecha]!.add(logro);
      } else {
        events[fecha] = [logro];
      }
    }
    return events;
  }
}
