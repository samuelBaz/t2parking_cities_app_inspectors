import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar a la pantalla de inicio de sesión después de 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      context.go('/login'); // Cambia a la ruta de tu pantalla de inicio de sesión
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/splashCustom.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(child: Center(
            child: Image.asset('images/logo.png', width: 200,),
          )),
        ],
      ),
    );
  }
}