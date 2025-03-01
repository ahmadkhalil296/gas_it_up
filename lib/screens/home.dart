import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/menu/orders_screen.dart';
import 'package:mechanic_services/screens/menu/profile_screen.dart';
import 'package:mechanic_services/screens/menu/vehicule_details.dart';

import '../services/AuthService.dart';
import '../widgets/service_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: 36,), // Simple burger icon
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the drawer
            },
          ),
        ),
      ),
      drawer: Drawer(

        child: ListView(
          padding: EdgeInsets.only(top: 50),
          children: [

            ListTile(
              leading: Icon(Icons.person),
              title: Text("My Account"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text("My Car"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehicleInfoScreen()));

              },
            ),
            ListTile(
              leading: Icon(Icons.history ),
              title: Text("Order History"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrdersScreen()));

              },
            ),
            ListTile(
              leading: Icon(Icons.feedback_outlined  ),
              title: Text("Feedback"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                await AuthService().signOut();
                Navigator.popUntil(context, ModalRoute.withName('/login'));
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        
          children: [
            Text('Home',style: Theme.of(context).textTheme.headlineLarge,),
        
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children:
                  [
                    Text('Hello,',style: Theme.of(context).textTheme.headlineMedium,),
                    Text('Welcome back! Choose one of our services',style: Theme.of(context).textTheme.bodyMedium,),
        
                  ]
              ),
            ),
        const SizedBox(height: 20),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
        
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context,'/fuel_delivery');
      },
              child: ServiceCard(
                      imageUrl: "assets/images/fuel_icon.png",
                      title: "Fuel Delivery",
                      description: "Fast and efficient fuel delivery to get you back on the road.",
              ),
            ),
        
            GestureDetector(
              onTap:(){
                Navigator.pushNamed(context,'/car_wash');
            },
              child: ServiceCard(
                      imageUrl: "assets/images/car_wash_icon.png",
                      title: "Car Wash",
                      description: "Our mobile car wash comes to you!",
              ),
            ),
          ]
        ),

            const SizedBox(height: 20),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
        
                  GestureDetector(
                    onTap: (){
      Navigator.pushNamed(context,'/tire_change');
      },
                    child: const ServiceCard(
                      imageUrl: "assets/images/tire_change.png",
                      title: "Tire Change",
                      description: "Swift tire services wherever you are.",
                    ),
                  ),
        
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context,'/other_services');
                    },
                    child: ServiceCard(
                      imageUrl: "assets/images/other_services_icon.png",
                      title: "Other Services",
                      description: "Discover more services to keep your car in top shape.",
                    ),
                  ),
                ]
            ),
            const SizedBox(height: 20),
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
        
                  GestureDetector(
                    onTap: (){
      Navigator.pushNamed(context,'/car_accessories');
      },
                    child: ServiceCard(
                      imageUrl: "assets/images/car_accessories_icon.png",
                      title: "Car Accessories",
                      description: "Essential upgrades for your car",
                    ),
                  ),
        
                  ServiceCard(
                    imageUrl: "assets/images/chatbot_icon.png",
                    title: "AI Chat bot",
                    description: "Instant help, just a tap away!",
                  ),
                ]
            ),
            const SizedBox(height: 20),
            ]
        ),
      )
    );
  }
}
