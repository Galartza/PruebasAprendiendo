import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentacion/views/hoy_views.dart';
import 'package:flutter_application_1/presentacion/views/logros_view.dart';
import 'package:flutter_application_1/presentacion/views/tareas_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HoyViews(), // Corregido el nombre de la clase
      const TareasViews(),
      const LogrosViews(),
    ];
    final iconColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Aplicación',
          style: TextStyle(color: iconColor),
        ),
        backgroundColor: Color.fromARGB(255, 252, 19, 2),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: iconColor,
              size: 30,
            ),
            onPressed: () {
              // Agrega aquí la lógica para manejar las notificaciones
            },
          ),
        ],
        elevation: 0, // Elimina la sombra predeterminada de la AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 252, 19, 2),
                Color.fromARGB(255, 250, 66, 72), // Color degradado
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 9.0,
                spreadRadius: 1.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 252, 19, 2),
              Color.fromARGB(255, 250, 66, 72), // Color degradado
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 9.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: selectedIndex,
          onTap: (newIndex) {
            setState(() {
              selectedIndex = newIndex;
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, color: iconColor),
              activeIcon: Icon(Icons.calendar_month, color: iconColor),
              label: 'Hoy',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined, color: iconColor),
              activeIcon: Icon(Icons.task, color: iconColor),
              label: 'Tareas',
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium_outlined, color: iconColor),
              activeIcon:
                  Icon(Icons.workspace_premium_rounded, color: iconColor),
              label: 'Logros',
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
