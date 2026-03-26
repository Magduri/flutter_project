import 'package:flutter/material.dart';
import 'package:flutter_project/screens/bottom_navigation.dart';
import 'package:flutter_project/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp( MainApp(isLoggedIn: isLoggedIn) );
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MainApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'MediCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00796B),
      ),
      home: isLoggedIn ? const BottomNavigation() : const LoginScreen(),
      );
  }
}
