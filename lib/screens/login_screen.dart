import 'package:flutter/material.dart';
import 'package:flutter_project/screens/home_screen.dart'; 
import 'package:flutter_project/screens/bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFFF5F7FA),
       body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MediCare',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00796B),
                  ),
                ),
                const SizedBox(height: 50),
          
                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress, 
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white, 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), 
                        borderSide: BorderSide.none, 
                      ),
                    ),
                  ),
          
                const SizedBox(height: 20),
                TextField(
                    controller: _passwordController,
                    obscureText: true, 
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40), 

                SizedBox(
                  width: double.infinity, 
                  height: 50, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00796B), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0), 
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavigation(),
                        ),
                      );
                    },
                    child: const Text(
                      'LOG IN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      );
  } 
}