import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t2parking_cities_inspector_app/constants/colors.dart';
import 'package:t2parking_cities_inspector_app/models/ticket.dart';
import 'package:t2parking_cities_inspector_app/services/api_service.dart';
import 'package:t2parking_cities_inspector_app/utils/string_utils.dart';
import 'package:t2parking_cities_inspector_app/widgets/tc_button.dart';

class ConsultScreen extends StatefulWidget {
  const ConsultScreen({Key? key}) : super(key: key);

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
  String messageResult = "Introduce una matricula para ver sus tickets.";
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    _getPrefences();
    apiService = ApiService(context: context);
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
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextFormField(
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu matrícula';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _matricula =
                                  value
                                      ?.toUpperCase();
                              
                              if(value!.isEmpty) {
                                setState(() {
                                  tickets = [];
                                  messageResult = "Introduce una matricula para ver sus tickets.";
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
                  SizedBox(height: 24),
                  _isLoading
                      ? CircularProgressIndicator()
                      : tickets.isEmpty
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
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipPath(
                                  clipper: TriangleClipper(),
                                  child: Container(
                                    height: 16,
                                    width:
                                        MediaQuery.of(
                                          context,
                                        ).size.width, // Ancho del triángulo
                                    color:
                                        AppColors
                                            .secondaryColor, // Color del triángulo
                                  ),
                                ),
                                SizedBox(height: 16),
                                Center(
                                  child: Image.asset(
                                    'images/logo.png',
                                    width: 200,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16, bottom: 8),
                                  color: Colors.black,
                                  height: 2,
                                  width: double.infinity,
                                ),
                                Center(
                                  child: Text(
                                    'TICKET DE ESTACIONAMIENTO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 8),
                                  color: Colors.black,
                                  height: 2,
                                  width: double.infinity,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.arrow_right_alt_sharp),
                                              Text('Desde : '),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [Text('Hasta : ')],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [Text(formatUtcToLocal(ticket.startDate.toString()))],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [Text(formatUtcToLocal(ticket.endDate.toString())), Icon(Icons.arrow_right_alt),],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Center(child: Text('MONTO : ${ticket.amount}', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),)),

                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 16),
                                  color: Colors.black,
                                  height: 2,
                                  width: double.infinity,
                                ),
                                ClipPath(
                                  clipper: TriangleClipper(),
                                  child: Container(
                                    height: 16,
                                    width:
                                        MediaQuery.of(
                                          context,
                                        ).size.width, // Ancho del triángulo
                                    color:
                                        AppColors
                                            .secondaryColor, // Color del triángulo
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
          '/api/tickets/getTodayTicketsByCity/$cityId/ByPlate/$_matricula/ByInspector/$inspectorId',
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          List<dynamic> content = data['data']['content'];
          tickets =
              content
                  .map((ticketJson) => Ticket.fromJson(ticketJson))
                  .toList(); // Parsear a lista de Tickets
          if (tickets.length == 0) {
            setState(() {
              messageResult =
                  "La matrícula: $_matricula no tiene ningún ticket para el día de hoy.";
            });
          }
          print(tickets); // Imprimir la lista de tickets
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
        tickets = [];
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0); // Punto superior central (pico)
    path.lineTo(size.width, size.height); // Punto inferior derecho
    path.lineTo(0, size.height); // Punto inferior izquierdo
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
