import 'package:flutter/material.dart';

class LicensePlate extends StatelessWidget {
  final String plate;
  const LicensePlate({Key? key, required this.plate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white, // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(3), // Bordes redondeados
        border: Border.all(
          // Define el borde
          color: Colors.black, // Color del borde
          width: 2.0, // Ancho del borde
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue[800],
            alignment: Alignment.center,
            child: Text(
              "MATRICULA",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
          Text(
            plate,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
