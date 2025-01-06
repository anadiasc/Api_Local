import 'package:flutter/material.dart';
import 'package:sharing_app/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  // Função para navegar para a HomePage após um tempo
  _navigateToHomePage() async {
    await Future.delayed(Duration(seconds: 2)); // Tela de splash por 4 segundos
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03457C), // Cor de fundo da splash screen
      body: Center(
        child: Text(
          'Sharing App',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}