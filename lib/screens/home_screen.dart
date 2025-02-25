import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t2parking_cities_inspector_app/constants/colors.dart';
import 'package:t2parking_cities_inspector_app/models/inspector_events.dart';
import 'package:t2parking_cities_inspector_app/services/api_service.dart';
import 'package:t2parking_cities_inspector_app/services/inspector_service.dart';
import 'package:t2parking_cities_inspector_app/utils/string_utils.dart';
import 'package:t2parking_cities_inspector_app/widgets/license_plate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InspectorService inspectorService;
  late ApiService apiService;
  late int inspectorId;
  List<InspectorEvent> events = [];

  @override
  void initState() {
    super.initState();
    inspectorService = new InspectorService(context: context);
    apiService = new ApiService(context: context);
    _getUserPreference();
  }

  Future<void> _getUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getInt('user'); // Obtiene la preferencia 'user'

    if (user != null) {
      inspectorId = user;
      _fetchInspectorEvents();
    } else {
      Fluttertoast.showToast(
        msg: 'No se encontró el usuario.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      context.go('/login');
    }
  }

  Future<void> _fetchInspectorEvents() async {
    try {
      final fetchedEvents = await inspectorService.getInspectorEvents(
        inspectorId,
      );
      setState(() {
        events = fetchedEvents; // Almacena los eventos en la lista
      });
    } catch (e) {
      print('Error al obtener eventos: $e');
      apiService.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cities Inspectores',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: AppColors.primaryColor),
        ),
        bottomOpacity: 0.5,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.check_circle)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:
              events.isEmpty
                  ? Center(
                    child: CircularProgressIndicator(),
                  ) // Muestra un indicador de carga
                  : RefreshIndicator(
                    onRefresh: _fetchInspectorEvents,
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white, // Color de fondo del ticket
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // Bordes redondeados
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                  0.5,
                                ), // Sombra del ticket
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(
                                  0,
                                  1,
                                ), // Cambia la posición de la sombra
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6, // 60% del espacio
                                child: Container(
                                  // Color de fondo para visualizar el espacio
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            event.typeEvent == "PENALIZE"
                                                ? Icons.warning_rounded
                                                : Icons
                                                    .car_crash_rounded, // Ícono de advertencia
                                            color:
                                                event.typeEvent == "PENALIZE"
                                                    ? Colors.red
                                                    : Colors
                                                        .yellow, // Color del ícono
                                            size: 30.0, // Tamaño del ícono
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            event.typeEvent == "PENALIZE"
                                                ? "MULTA"
                                                : "CONSULTA",
                                            style: TextStyle(
                                              color:
                                                  event.typeEvent == "PENALIZE"
                                                      ? Colors.red
                                                      : Colors.yellow,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Descripción: ${event.description}',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        formatUtcToLocal(event.createdAt),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3, // 30% del espacio
                                child: LicensePlate(plate: event.plate),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/consult');
        },
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.check_circle, color: Colors.white),
      ),
    );
  }
}
