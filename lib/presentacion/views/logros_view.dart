import 'package:flutter/material.dart';

class LogrosViews extends StatefulWidget {

  const LogrosViews({super.key});

  @override
  State<LogrosViews> createState() => _LogrosViewsState();
}

class _LogrosViewsState extends State<LogrosViews> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current logros: $count'),
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