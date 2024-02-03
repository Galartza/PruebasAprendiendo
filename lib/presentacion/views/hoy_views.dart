import 'package:flutter/material.dart';

class HoyViews extends StatefulWidget {

  const HoyViews({super.key});

  @override
  State<HoyViews> createState() => _HoyViewsState();
}

class _HoyViewsState extends State<HoyViews> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current hoy: $count'),
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