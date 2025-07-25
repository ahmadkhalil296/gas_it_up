import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/back_button.dart';
import 'package:mechanic_services/screens/admin/manage_users.dart';
import 'package:mechanic_services/screens/admin/manage_orders.dart';
import 'package:mechanic_services/screens/admin/manage_services.dart';
import 'package:mechanic_services/screens/admin/manage_feedback.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    Text(
                      'Admin Dashboard',
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                  ],
                ),
                SizedBox(height: 30),
                _buildAdminCard(
                  context,
                  'Manage Users',
                  Icons.people,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageUsers()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildAdminCard(
                  context,
                  'Manage Orders',
                  Icons.shopping_cart,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageOrders()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildAdminCard(
                  context,
                  'Manage Services',
                  Icons.miscellaneous_services,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageServices()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildAdminCard(
                  context,
                  'Manage Feedback',
                  Icons.feedback,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageFeedback()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildAdminCard(
                  context,
                  'Analytics',
                  Icons.analytics,
                  () {
                    // TODO: Implement analytics screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Analytics feature coming soon!')),
                    );
                  },
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: const CustomBackButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Color.fromRGBO(16, 56, 127, 0.8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    );
  }
} 