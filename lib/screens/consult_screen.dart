import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t2parking_cities_inspector_app/constants/colors.dart';
import 'package:t2parking_cities_inspector_app/models/inspector_events.dart';
import 'package:t2parking_cities_inspector_app/services/api_service.dart';
import 'package:t2parking_cities_inspector_app/utils/string_utils.dart';
import 'package:t2parking_cities_inspector_app/widgets/tc_button.dart';
import 'package:t2parking_cities_inspector_app/widgets/tc_ticket.dart';
import 'package:flutter/services.dart';

class ConsultScreen extends StatefulWidget {
  final String id;

  const ConsultScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ConsultScreenState createState() => _ConsultScreenState();
}

class _ConsultScreenState extends State<ConsultScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _matricula;
  bool _isLoading = false;
  late final int inspectorId;
  late final int cityId;
  late final ApiService apiService;
  String messageResult = "Introduce una matrícula para ver sus tickets.";
  InspectorEvent? event;
  late final TextEditingController _matriculaController;

  @override
  void initState() {
    super.initState();
    _getPrefences();
    apiService = ApiService(context: context);
    _matriculaController = TextEditingController();

    if (widget.id != 'NEW') {
      _getEventSeleted(widget.id);
    }

    _matriculaController.text = "";
  }

  void _getPrefences() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getInt('user');
    final city = prefs.getInt('city');

    if (user != null && city != null) {
      inspectorId = user;
      cityId = city;
    } else {
      apiService.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.55,
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
                              "MATRÍCULA",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _matriculaController,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26),
                            textCapitalization: TextCapitalization.characters,
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9]*$'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa tu matrícula';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _matricula =
                                  _matriculaController.text.toUpperCase();

                              if (_matricula!.isEmpty) {
                                setState(() {
                                  event = null;
                                  messageResult =
                                      "Introduce una matrícula para ver sus tickets.";
                                });
                              }
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
                    onPressed: () {
                      _handleConsult();
                    },
                  ),
                  SizedBox(height: 16),
                  _isLoading || event == null
                      ? SizedBox()
                      : Container(
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
                        child: Container(
                          margin: EdgeInsets.only(right: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Fecha inspección: ',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    formatUtcToLocal(event!.createdAt),
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
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    'Resultado: ',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          event!.status == "EXPIRED"
                                              ? Icons.watch_later_outlined
                                              : event!.status == 'ACTIVE'
                                              ? Icons.check_circle_outline
                                              : Icons
                                                  .warning_amber_rounded, // Ícono de advertencia
                                          color:
                                              event!.status == "EXPIRED"
                                                  ? Colors.yellow.shade900
                                                  : event!.status == 'ACTIVE'
                                                  ? Colors.green.shade900
                                                  : Colors
                                                      .red
                                                      .shade900, // Color del ícono
                                          size: 21.0, // Tamaño del ícono
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          event!.status == 'ACTIVE'
                                              ? 'TICKET ACTIVO'
                                              : event!.status == 'EXPIRED'
                                              ? 'TICKET VENCIDO'
                                              : 'SIN TICKET',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:
                                                event!.status == "EXPIRED"
                                                    ? Colors.yellow.shade900
                                                    : event!.status == 'ACTIVE'
                                                    ? Colors.green.shade900
                                                    : Colors.red.shade900,
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
                  SizedBox(height: 16),
                  _isLoading
                      ? CircularProgressIndicator()
                      : event != null && event?.tickets!.length == 0
                      ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
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
                                messageResult,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.blue),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      )
                      : event != null
                      ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: event!.tickets?.length,
                        itemBuilder: (context, index) {
                          final ticket = event!.tickets?[index];
                          return TCTicket(ticket: ticket!);
                        },
                      )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleConsult() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await apiService.get(
          '/api/inspector_events/inspect?plate=$_matricula&userId=$inspectorId',
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          Map<String, dynamic> content = data['data'];
          event = InspectorEvent.fromJson(content);

          if (event!.tickets!.length == 0) {
            setState(() {
              messageResult =
                  "La matrícula $_matricula no tiene ningún ticket para el día de hoy.";
            });
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Error de consulta: ${response.statusCode} ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // tickets = [];
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _getEventSeleted(String eventId) async {
    // if (_formKey.currentState!.validate()) {
    // _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await apiService.get(
        '/api/inspector_events/inspect/$eventId',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Map<String, dynamic> content = data['data'];
        event = InspectorEvent.fromJson(content);
        _matriculaController.text = event!.plate;
        if (event!.tickets!.length == 0) {
          setState(() {
            messageResult =
                "La matrícula ${event!.plate} no tiene ningún ticket para el día de hoy.";
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Error de consulta: ${response.statusCode} ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // tickets = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    // }
  }
}
