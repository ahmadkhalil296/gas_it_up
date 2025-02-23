import 'package:firebase_core/firebase_core.dart';
import 'package:mechanic_services/screens/services/car_accessories.dart';
import 'package:mechanic_services/screens/services/car_wash.dart';
import 'package:mechanic_services/screens/services/fuel_delivery/fuel_delivery.dart';
import 'package:mechanic_services/screens/services/other_services.dart';
import 'package:mechanic_services/screens/services/tire_change.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/home.dart';
import 'package:mechanic_services/screens/informative.dart';
import 'package:mechanic_services/screens/informative_screens/about.dart';
import 'package:mechanic_services/screens/registration/login.dart';
import 'package:mechanic_services/screens/registration/sign_up.dart';
import 'package:mechanic_services/screens/registration/vehicule_info.dart';

import 'GradientBackground.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/about': (context) => About(),
          '/login': (context) => Login(),
          '/sign_up': (context) => SignUp(),
          '/home': (context) => HomePage(),
          '/fuel_delivery': (context) => FuelDelivery(),
          '/car_wash' : (context) => CarWash(),
          '/tire_change' : (context) => TireChange(),
          '/other_services' : (context) => OtherServices(),
          '/car_accessories' : (context) => CarAccesories(),
        },
        theme: ThemeData(
          textTheme: const TextTheme(
            // Set default text color to white
            bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
            // Set heading text style
            headlineMedium: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            headlineLarge: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),

          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 117, 18, 1),
              foregroundColor:Colors.white, // Button text color
              textStyle: const TextStyle(fontSize: 16),
              // Button text style
            ),
          ),
        ),

        builder: (context, child) {
          return GradientBackground(child: child!);
        },
        home:  Informative());
  }
}

