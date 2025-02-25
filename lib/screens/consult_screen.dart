import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t2parking_cities_inspector_app/constants/colors.dart';
import 'package:t2parking_cities_inspector_app/widgets/license_plate.dart';
import 'package:t2parking_cities_inspector_app/widgets/tc_button.dart';

class ConsultScreen extends StatefulWidget {
  const ConsultScreen({Key? key}) : super(key: key);

  @override
  _ConsultScreenState createState() => _ConsultScreenState();
}

class _ConsultScreenState extends State<ConsultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Consultar',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: AppColors.primaryColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () {
            context.pop(); // Navega hacia atrás
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white, // Color de fondo del contenedor
                    borderRadius: BorderRadius.circular(
                      3,
                    ), // Bordes redondeados
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
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 26),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 26,
                            color: Colors.grey,
                          ),
                          hintText: 'ABC123',
                          border: InputBorder.none,
                          alignLabelWithHint: false,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo electrónico';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Por favor ingresa un correo electrónico válido';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              TCButton(
                text: 'Consultar',
                color: AppColors.primaryColor,
                textColor: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
