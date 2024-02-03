import 'package:flutter/material.dart';

class HomeViews extends StatefulWidget {

  const HomeViews({super.key});

  @override
  State<HomeViews> createState() => _HomeViewsState();
}

class _HomeViewsState extends State<HomeViews> {

  int count = 0;

@override
Widget build(BuildContext context) {
  return Center(
    child: Container(
      width: 300, // Ajusta el ancho del contenedor según tus necesidades
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Current home: $count'),
          _buildCustomButton(Icons.sports_outlined, Color.fromARGB(255, 7, 131, 233), 'Deportes', () {
            setState(() {
              count++;
            });
          }),
          _buildCustomButton(Icons.school_outlined, const Color.fromARGB(255, 2, 185, 8), 'Educación', () {
            setState(() {
              count++;
            });
          }),
          _buildCustomButton(Icons.work_outline, const Color.fromARGB(255, 255, 153, 0), 'Trabajo', () {
            setState(() {
              count++;
            });
          }),
          _buildCustomButton(Icons.health_and_safety_outlined, const Color.fromARGB(255, 247, 20, 4), 'Salud', () {
            setState(() {
              count++;
            });
          }),
        ],
      ),
    ),
  );
}

Widget _buildCustomButton(IconData icon, Color backgroundColor, String buttonText, VoidCallback onPressed) {
  return FilledButton.tonal(
    onPressed: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 40), // Ajusta el tamaño del icono aquí
        SizedBox(width: 8), // Espacio entre el icono y el texto
        Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20, // Ajusta el tamaño del texto aquí
          ),
        ), // Texto al lado derecho del icono
      ],
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      minimumSize: MaterialStateProperty.all<Size>(Size(150, 100)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
       shadowColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.9)), // Color y opacidad de la sombra
      elevation: MaterialStateProperty.all<double>(20), // Altura de la sombra
    ),
  );
}





}