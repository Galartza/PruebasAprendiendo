import 'package:flutter/material.dart';

class TareasViews extends StatefulWidget {

  const TareasViews({super.key});

  @override
  State<TareasViews> createState() => _TareasViewsState();
}

class _TareasViewsState extends State<TareasViews> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current tareas: $count'),
          FilledButton.tonal(
            onPressed: () {
              setState(() {
                count++;
              });
            },child: const Icon( Icons.add )),
        ],
      )
    );   
  }
}