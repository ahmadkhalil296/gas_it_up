import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/menu/orders_screen.dart';
import 'package:mechanic_services/screens/menu/profile_screen.dart';
import 'package:mechanic_services/screens/menu/vehicule_details.dart';
import 'package:mechanic_services/screens/menu/admin_dashboard.dart';
import 'package:mechanic_services/screens/feedback.dart';
import 'package:mechanic_services/screens/menu/settings_screen.dart';
import 'package:mechanic_services/screens/informative_screens/about.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mechanic_services/screens/order/track_order.dart';
import 'package:mechanic_services/screens/chatbot/chatbot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/AuthService.dart';
import '../widgets/service_card.dart';
import '../services/local_storage_service.dart';

/// Displays available services and provides navigation to different sections
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAdmin = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _fetchUserName();
  }

  /// Fetches the user's first name from Firestore
  /// Updates the userName state variable if successful
  Future<void> _fetchUserName() async {
    try {
      String? uid = AuthService().getCurrentUserId();
      if (uid != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          setState(() {
            userName = userData['firstName'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  /// Checks if the current user has admin privileges
  /// Updates the isAdmin state variable based on the username
  Future<void> _checkAdminStatus() async {
    String? username = await AuthService().getCurrentUsername();
    // List of admin usernames
    final List<String> adminUsernames = ["ahmadkhalil", "aymanaboujmei"];

    setState(() {
      isAdmin = username != null && adminUsernames.contains(username);
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Cleanup resources
      await LocalStorageService().clearUser();

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Pop the loading dialog
      Navigator.of(context).pop();

      // Navigate to login screen and clear the navigation stack
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      // Pop the loading dialog if it's showing
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to logout: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        // Custom app bar with menu button
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: 36,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        // Navigation drawer with all app sections
        drawer: Drawer(
          backgroundColor: Color.fromRGBO(16, 56, 127, 1),
          child: ListView(
            padding: EdgeInsets.only(top: 50),
            children: [
              // My Account section
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title:
                    Text("My Account", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserProfileScreen()));
                },
              ),
              // My Car section
              ListTile(
                leading: Icon(Icons.directions_car, color: Colors.white),
                title: Text("My Car", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VehicleInfoScreen()));
                },
              ),
              // Order History section
              ListTile(
                leading: Icon(Icons.history, color: Colors.white),
                title: Text("Order History",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrdersScreen()));
                },
              ),
              // Track Order section
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.white),
                title:
                    Text("Track Order", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TrackOrderScreen()));
                },
              ),
              // Admin Dashboard section (only visible to admins)
              if (isAdmin)
                ListTile(
                  leading:
                      Icon(Icons.admin_panel_settings, color: Colors.white),
                  title: Text("Admin Dashboard",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AdminDashboard()));
                  },
                ),
              // Feedback section
              ListTile(
                leading: Icon(Icons.feedback_outlined, color: Colors.white),
                title: Text("Feedback", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  );
                },
              ),
              // Settings section
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text("Settings", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              // About Us section
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.white),
                title: Text("About Us", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => About()),
                  );
                },
              ),
              // Logout section
              ListTile(
                leading: Icon(Icons.logout, color: Colors.white),
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () => _handleLogout(context),
              ),
            ],
          ),
        ),
        // Main content area with service cards
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header section
                Text('Home', style: Theme.of(context).textTheme.headlineLarge),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello${userName.isNotEmpty ? " $userName," : ""}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'Welcome back! Choose one of our services',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ]),
                ),
                const SizedBox(height: 20),
                // Service cards grid
                // First row: Fuel Delivery and Car Wash
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/fuel_delivery');
                          },
                          child: SizedBox(
                            height: 200,
                            width: 190,
                            child: ServiceCard(
                              imageUrl: "assets/images/fuel_icon.png",
                              title: "Fuel Delivery",
                              description:
                                  "Fast and efficient fuel delivery to get you back on the road.",
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/car_wash');
                          },
                          child: SizedBox(
                            height: 200,
                            width: 190,
                            child: ServiceCard(
                              imageUrl: "assets/images/car_wash_icon.png",
                              title: "Car Wash",
                              description: "Our mobile car wash comes to you!",
                            ),
                          )),
                    ]),
                const SizedBox(height: 20),
                // Second row: Tire Change and Other Services
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/tire_change');
                          },
                          child: SizedBox(
                            height: 200,
                            width: 190,
                            child: const ServiceCard(
                              imageUrl: "assets/images/tire_change.png",
                              title: "Tire Change",
                              description:
                                  "Swift tire services wherever you are.",
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/other_services');
                          },
                          child: SizedBox(
                            height: 200,
                            width: 190,
                            child: ServiceCard(
                              imageUrl: "assets/images/other_services_icon.png",
                              title: "Other Services",
                              description:
                                  "Our services keep your car in top shape.",
                            ),
                          )),
                    ]),
                const SizedBox(height: 20),
                // Third row: Car Accessories and AI Chatbot
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/car_accessories');
                          },
                          child: SizedBox(
                            height: 200,
                            width: 190,
                            child: ServiceCard(
                              imageUrl:
                                  "assets/images/car_accessories_icon.png",
                              title: "Car Accessories",
                              description: "Essential upgrades for your car",
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatbotScreen()),
                            );
                          },
                          child: SizedBox(
                            height: 200,
                            width: 190,
                            child: ServiceCard(
                              imageUrl: "assets/images/chatbot_icon.png",
                              title: "AI Chat bot",
                              description: "Instant help, just a tap away!",
                            ),
                          )),
                    ]),
                const SizedBox(height: 20),
              ]),
        ));
  }
}
