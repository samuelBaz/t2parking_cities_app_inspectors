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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    inspectorService = new InspectorService(context: context);
    apiService = new ApiService(context: context);
    _getUserPreference();
  }

  Future<void> _getUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getInt('user');

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
      apiService.logout();
    }
  }

  Future<void> _fetchInspectorEvents() async {
    try {
      final fetchedEvents = await inspectorService.getInspectorEvents(
        inspectorId,
      );
      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      print('Error al obtener eventos: $e');
    } finally {
      setState(() {
        loading = false;
      });
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
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "EXIT") {
                apiService.logout();
              }
            },
            offset: Offset(0, 50),
            menuPadding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'EXIT',
                  child: Text('Cerrar Sesión'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child:
              loading
                  ? Center(
                    child: CircularProgressIndicator(),
                  ) // Muestra un indicador de carga
                  : events.isEmpty
                  ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blueAccent),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Sin historial de consultas recientes...',
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.blue),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () => _fetchInspectorEvents(),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh_outlined,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Actualizar',
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: AppColors.primaryColor),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                  : RefreshIndicator(
                    onRefresh: _fetchInspectorEvents,
                    child: ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return GestureDetector(
                          onTap: () {
                            context.push('/consult/${event.id}');
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 1,
                            ),
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
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6, // 60% del espacio
                                      child: Container(
                                        margin: EdgeInsets.only(right: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors
                                                            .blue[700], // Color de fondo del ticket
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.0,
                                                        ), // Bordes redondeados
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
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
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 2,
                                                    horizontal: 8,
                                                  ),
                                                  child: Text(
                                                    event.typeEvent ==
                                                            "PENALIZE"
                                                        ? "MULTA"
                                                        : "CONSULTA",
                                                    style: TextStyle(
                                                      color:
                                                          event.typeEvent ==
                                                                  "PENALIZE"
                                                              ? Colors.red
                                                              : Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Text(
                                                  'Fecha inspección: ',
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                ),
                                                Text(
                                                  formatUtcToLocal(
                                                    event.createdAt,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        fontSize: 11,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Text(
                                                  'Resultado: ',
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        event.status ==
                                                                "EXPIRED"
                                                            ? Icons
                                                                .watch_later_outlined
                                                            : event.status ==
                                                                'ACTIVE'
                                                            ? Icons
                                                                .check_circle_outline
                                                            : Icons
                                                                .warning_amber_rounded, // Ícono de advertencia
                                                        color:
                                                            event.status ==
                                                                    "EXPIRED"
                                                                ? Colors
                                                                    .yellow
                                                                    .shade900
                                                                : event.status ==
                                                                    'ACTIVE'
                                                                ? Colors
                                                                    .green
                                                                    .shade900
                                                                : Colors
                                                                    .red
                                                                    .shade900, // Color del ícono
                                                        size:
                                                            21.0, // Tamaño del ícono
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        event.status == 'ACTIVE'
                                                            ? 'CON TICKET ACTIVO'
                                                            : event.status ==
                                                                'EXPIRED'
                                                            ? 'CON TICKET VENCIDO'
                                                            : 'SIN TICKET',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color:
                                                              event.status ==
                                                                      "EXPIRED"
                                                                  ? Colors
                                                                      .yellow
                                                                      .shade900
                                                                  : event.status ==
                                                                      'ACTIVE'
                                                                  ? Colors
                                                                      .green
                                                                      .shade900
                                                                  : Colors
                                                                      .red
                                                                      .shade900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/consult/NEW');
        },
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.check_circle, color: Colors.white),
      ),
    );
  }
}
