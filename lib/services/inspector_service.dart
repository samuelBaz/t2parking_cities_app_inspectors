import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:t2parking_cities_inspector_app/models/inspector_events.dart';
import 'package:t2parking_cities_inspector_app/services/api_service.dart';

class InspectorService {
  final ApiService apiService; 
  final BuildContext context;
  InspectorService({required this.context}) : apiService = new ApiService(context: context);

  Future<List<InspectorEvent>> getInspectorEvents(int id) async {
    final response = await apiService.get('/api/inspector_events/getAllByUser/$id');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonData = jsonResponse['data']['content'];
      return jsonData.map((event) => InspectorEvent.fromJson(event)).toList();
    } else {
      throw Exception('Error al obtener eventos del inspector: ${response.statusCode}');
    }
  }
}