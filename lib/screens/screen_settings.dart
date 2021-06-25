import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text('Settings')),
      ),
    );
  }
}
