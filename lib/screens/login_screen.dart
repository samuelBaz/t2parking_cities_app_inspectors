import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t2parking_cities_inspector_app/constants/colors.dart';
import 'package:t2parking_cities_inspector_app/exceptions/login_exception.dart';
import 'package:t2parking_cities_inspector_app/services/api_service.dart';
import 'package:t2parking_cities_inspector_app/widgets/tc_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _obscureText = true;
  bool _isLoading = false;
  late final ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(context: context);
    _checkToken();
  }

  Future<void> _checkToken() async {
    final isValid = await apiService.isTokenValid();

    if (isValid) {
      context.go('/home');
    } else {
      // El token es válido
      print('Token activo: $isValid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Login to your Account',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      hintText: 'ejemplo@correo.com',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColors.primaryColor,
                      ),
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
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // Cambia el estado de visibilidad
                          });
                        },
                      ),
                    ),
                    obscureText:
                        _obscureText, // Usa el estado para mostrar/ocultar
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 8) {
                        return 'La contraseña debe tener al menos 8 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: 64.0),
                  TCButton(
                    text: 'Iniciar Sesión',
                    color: AppColors.primaryColor,
                    textColor: Colors.white,
                    onPressed: _isLoading ? () {} : () {
                      _handleLogin();
                    }
                  ),
                  SizedBox(height: 24.0),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Olvidaste tu contraseña?",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await apiService.login(
          _email!,
          _password!,
        );

        if (response.statusCode == 200) {
          context.go('/home');
        } else {
          Fluttertoast.showToast(
            msg: 'Error de inicio de sesión: ${response.statusCode} ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        if (e is LoginException) {
          Fluttertoast.showToast(
            msg: e.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Error: $e',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
