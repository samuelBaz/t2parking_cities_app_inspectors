import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:t2parking_cities_inspector_app/constants/colors.dart';
import 'package:t2parking_cities_inspector_app/navigation/app_routes.dart';
import 'package:timezone/data/latest.dart' as tz;

main()  {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mi Aplicación',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Habilita Material 3
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ), // bodyText1
          bodySmall: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ), 
          titleLarge: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ), // headline6
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 14.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor, // Color de fondo del botón
            foregroundColor: Colors.white, // Color del texto del botón
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
        ),
      ),
    );
  }
}
