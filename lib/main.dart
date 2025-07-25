import 'package:firebase_core/firebase_core.dart';
import 'package:mechanic_services/screens/services/car_accessories.dart';
import 'package:mechanic_services/screens/services/car_wash.dart';
import 'package:mechanic_services/screens/services/fuel_delivery/fuel_delivery.dart';
import 'package:mechanic_services/screens/services/other_services.dart';
import 'package:mechanic_services/screens/services/tire_change.dart';
import 'package:mechanic_services/screens/chatbot/chatbot_screen.dart';
import 'package:mechanic_services/screens/order/track_order_map.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/home.dart';
import 'package:mechanic_services/screens/informative.dart';
import 'package:mechanic_services/screens/informative_screens/about.dart';
import 'package:mechanic_services/screens/registration/login.dart';
import 'package:mechanic_services/screens/registration/sign_up.dart';
import 'package:mechanic_services/screens/registration/vehicule_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

import 'GradientBackground.dart';

/// Initializes Firebase and Google Maps before running the app
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Google Maps for Android platform
  if (DefaultFirebaseOptions.currentPlatform ==
      DefaultFirebaseOptions.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  // Set custom error handler for better error visualization
  ErrorWidget.builder = (FlutterErrorDetails details) {
    print('Error in app: ${details.exception}');
    return Container(
      color: Colors.red,
      child: Center(
        child: Text(
          'Error: ${details.exception}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  };

  runApp(const MyApp());
}

/// Configures the app's theme, routes, and overall structure
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gas It Up',
        debugShowCheckedModeBanner: false,
        // Use home property for initial screen
        home: Informative(),
        // Define routes for navigation
        routes: {
          '/about': (context) => About(),
          '/login': (context) => Login(),
          '/sign_up': (context) => SignUp(),
          '/home': (context) => HomePage(),
          '/fuel_delivery': (context) => FuelDelivery(),
          '/car_wash': (context) => CarWash(),
          '/tire_change': (context) => TireChange(),
          '/other_services': (context) => OtherServices(),
          '/car_accessories': (context) => CarAccesories(),
          '/chatbot': (context) => const ChatbotScreen(),
          '/track_order_map': (context) => TrackOrderMap(
              orderId: ModalRoute.of(context)!.settings.arguments as String),
        },
        // Configure app-wide theme
        theme: ThemeData(
          textTheme: const TextTheme(
            // Default text style for body text
            bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
            // Style for medium-sized headings
            headlineMedium: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            // Style for large headings
            headlineLarge: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          // Configure elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 117, 18, 1),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        // Wrap all screens with gradient background
        builder: (context, child) {
          return GradientBackground(child: child!);
        });
  }
}
