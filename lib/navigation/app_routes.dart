import 'package:go_router/go_router.dart';
import 'package:t2parking_cities_inspector_app/screens/consult_screen.dart';
import 'package:t2parking_cities_inspector_app/screens/home_screen.dart';
import 'package:t2parking_cities_inspector_app/screens/login_screen.dart';
import 'package:t2parking_cities_inspector_app/screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/consult',
      builder: (context, state) => ConsultScreen(),
    ),
  ],
); 