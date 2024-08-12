import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

  // Initialize periodic usage registration
  Timer.periodic(Duration(minutes: 1), (timer) {
    registerUsage(1); // Registers 1 minute of usage every minute
  });
}

void registerUsage(int minutesUsed) async {
  final DatabaseReference usageRef = FirebaseDatabase.instance.ref().child('usage');
  final String today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format

  final snapshot = await usageRef.child(today).get();
  final currentMinutes = snapshot.value as int? ?? 0;

  await usageRef.child(today).set(currentMinutes + minutesUsed);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainWave',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
