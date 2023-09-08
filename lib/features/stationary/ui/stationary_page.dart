import 'package:flutter/material.dart';

class StationaryPage extends StatefulWidget {
  const StationaryPage({super.key});

  @override
  State<StationaryPage> createState() => _StationaryPageState();
}

class _StationaryPageState extends State<StationaryPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Stationary Page'),
      ),
    );
  }
}
