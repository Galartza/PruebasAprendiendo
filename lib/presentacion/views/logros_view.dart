import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'dart:convert';

enum EstadoActividad { noConcretado, pendiente, enCurso, concretado }

void main() {
  runApp(MaterialApp(
    home: LogrosViews(),
  ));
}

class Actividad {
  final String nombre;
  final String categoria;
  final DateTime fechaDesde;
  final DateTime fechaHasta;
  final String ubicacionDesde;
  final String ubicacionHasta;

  Actividad({
    required this.nombre,
    required this.categoria,
    required this.fechaDesde,
    required this.fechaHasta,
    required this.ubicacionDesde,
    required this.ubicacionHasta,
  });

  EstadoActividad determinarEstado() {
    final ahora = DateTime.now();
    if (ahora.isBefore(fechaDesde)) {
      return EstadoActividad.noConcretado;
    } else if (ahora.isAfter(fechaHasta)) {
      return EstadoActividad.concretado;
    } else if (ahora.isAfter(fechaDesde) && ahora.isBefore(fechaHasta)) {
      return EstadoActividad.enCurso;
    } else {
      return EstadoActividad.pendiente;
    }
  }
}

class LogrosViews extends StatefulWidget {
  const LogrosViews({Key? key}) : super(key: key);

  @override
  State<LogrosViews> createState() => _LogrosViewsState();
}

class _LogrosViewsState extends State<LogrosViews> {
  List<Actividad> actividades = [];
  String _selectedCategoria = 'Deporte';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tus Logros'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildActividadesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildActividadesList() {
    return ListView.builder(
      itemCount: actividades.length,
      itemBuilder: (context, index) {
        return _buildActividadItem(actividades[index]);
      },
    );
  }

  Widget _buildActividadItem(Actividad actividad) {
    final estado = actividad.determinarEstado();
    String estadoText = '';
    Color? cardColor;

    switch (estado) {
      case EstadoActividad.noConcretado:
        estadoText = 'No Concretado';
        cardColor = Colors.red.withOpacity(0.5); // Rojo transparente
        break;
      case EstadoActividad.pendiente:
        estadoText = 'Pendiente';
        cardColor = Colors.yellow.withOpacity(0.5); // Amarillo transparente
        break;
      case EstadoActividad.enCurso:
        estadoText = 'En Curso';
        cardColor = Colors.orange.withOpacity(0.5); // Naranja transparente
        break;
      case EstadoActividad.concretado:
        estadoText = 'Concretado';
        cardColor = Colors.green.withOpacity(0.5); // Verde transparente
        break;
    }

    return Card(
      margin: EdgeInsets.all(8.0),
      color: cardColor,
      child: ListTile(
        title: Text('Actividad: ${actividad.nombre}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categoría: ${actividad.categoria}'),
            Text('Estado: $estadoText'),
            Text('Fecha Desde: ${actividad.fechaDesde.toString()}'),
            Text('Fecha Hasta: ${actividad.fechaHasta.toString()}'),
            Text('Ubicación Desde: ${actividad.ubicacionDesde}'),
            Text('Ubicación Hasta: ${actividad.ubicacionHasta}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                _openGoogleMaps(actividad);
              },
            ),
            IconButton(
              icon: Icon(Icons.directions),
              onPressed: () {
                _iniciarRecorrido(actividad);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: FormularioActividad(
            onActividadCreated: (actividad) {
              setState(() {
                actividades.add(actividad);
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _openGoogleMaps(Actividad actividad) async {
    String ubicacionDesde = actividad.ubicacionDesde;
    String ubicacionHasta = actividad.ubicacionHasta;
    String mapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$ubicacionDesde&destination=$ubicacionHasta";

    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      print('No se pudo abrir Google Maps');
    }
  }

  void _iniciarRecorrido(Actividad actividad) async {
    String ubicacionDesde = actividad.ubicacionDesde;
    String ubicacionHasta = actividad.ubicacionHasta;
    String mapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$ubicacionDesde&destination=$ubicacionHasta";

    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      print('No se pudo abrir Google Maps');
    }
  }
}

class FormularioActividad extends StatefulWidget {
  final Function(Actividad) onActividadCreated;

  FormularioActividad({
    required this.onActividadCreated,
  });

  @override
  _FormularioActividadState createState() => _FormularioActividadState();
}

class _FormularioActividadState extends State<FormularioActividad> {
  final TextEditingController _actividadController = TextEditingController();
  final TextEditingController _ubicacionDesdeController = TextEditingController();
  final TextEditingController _ubicacionHastaController = TextEditingController();
  String _selectedCategoria = 'Deporte';
  DateTime _fechaDesde = DateTime.now();
  DateTime _fechaHasta = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nueva Actividad'),
          TextFormField(
            controller: _actividadController,
            decoration: InputDecoration(labelText: 'Actividad'),
          ),
          Row(
            children: [
              Expanded(
                child: _buildCategoriaDropDown(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  dateMask: 'yyyy-MM-dd HH:mm',
                  controller: TextEditingController(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Desde',
                  onChanged: (val) {
                    _fechaDesde = DateTime.parse(val);
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  dateMask: 'yyyy-MM-dd HH:mm',
                  controller: TextEditingController(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Hasta',
                  onChanged: (val) {
                    _fechaHasta = DateTime.parse(val);
                  },
                  validator: (val) {
                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ubicacionDesdeController,
                  decoration: InputDecoration(labelText: 'Ubicación Desde'),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _ubicacionHastaController,
                  decoration: InputDecoration(labelText: 'Ubicación Hasta'),
                ),
              ),
            ],
          ),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildCategoriaDropDown() {
    return DropdownButton<String>(
      value: _selectedCategoria,
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategoria = newValue!;
        });
      },
      items: <String>['Deporte', 'Educación', 'Trabajo', 'Salud']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ),
          )
          .toList(),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              _createActividad(context);
            },
            child: Text('Aceptar'),
          ),
          ElevatedButton(
            onPressed: () {
              _showCancelConfirmation(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _createActividad(BuildContext context) {
    String nombre = _actividadController.text;
    String categoria = _selectedCategoria;
    String ubicacionDesde = _ubicacionDesdeController.text;
    String ubicacionHasta = _ubicacionHastaController.text;

    Actividad nuevaActividad = Actividad(
      nombre: nombre,
      categoria: categoria,
      fechaDesde: _fechaDesde,
      fechaHasta: _fechaHasta,
      ubicacionDesde: ubicacionDesde,
      ubicacionHasta: ubicacionHasta,
    );

    widget.onActividadCreated(nuevaActividad);
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancelar Actividad'),
          content: Text('¿Estás seguro que quieres cancelar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }
}
