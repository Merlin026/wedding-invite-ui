import 'package:flutter/material.dart';
import 'package:wedding_invite/screens/invite_screen.dart';
import 'screens/rsvp_screen.dart';
import 'screens/invite_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'John & Carmel',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: InviteScreen(), // 👈 THIS is important
    );
  }
}