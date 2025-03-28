import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t2parking_cities_inspector_app/config.dart';
import 'package:t2parking_cities_inspector_app/exceptions/login_exception.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  final String baseUrl;
  final BuildContext context;

  ApiService({required this.context}) : baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    const bool isProduction = Config.isProd; // Cambia a true en producción
    return isProduction ? Config.baseUrlProd: Config.baseUrl;
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    // Lógica de validación del token (puedes personalizar esto)
    return token != null && token.isNotEmpty && !JwtDecoder.isExpired(token); // Ejemplo simple
  }

  Future<void> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/insecure/refreshToken'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final int status = data['status'];
      if(status == 0){
        await prefs.setString('token', data['token']['access_token']);
        await prefs.setString('refresh_token', data['token']['refresh_token']); 
      } else {
        logout();
      }
    } else {
      logout();
    }
  }

  Future<http.Response> get(String endpoint) async {
    if (!await isTokenValid()) {
      await _refreshToken(); // Intenta refrescar el token
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    // Si el token es inválido, intenta refrescarlo
    if (response.statusCode == 401) {
      await _refreshToken();
      return await get(endpoint); // Reintenta la solicitud
    }

    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    if (!await isTokenValid()) {
      await _refreshToken(); // Intenta refrescar el token
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    // Si el token es inválido, intenta refrescarlo
    if (response.statusCode == 401) {
      await _refreshToken();
      return await post(endpoint, data); // Reintenta la solicitud
    }

    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/insecure/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      dynamic user = data['user'];
      
      // Lanzar excepción si el rol no es INSPECTOR
      if (user == null || user['role'] != 'INSPECTOR') {
        throw LoginException('El usuario no esta autorizado');
      }
      await prefs.setInt('user', data['user']['id']);
      await prefs.setInt('city', data['user']['dependency']);
      await prefs.setString('token', data['token']['access_token']); // Guarda el token
      await prefs.setString('refresh_token', data['token']['refresh_token']); // Guarda el refresh token
    }

    return response;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    context.go('/login');
  }
}

