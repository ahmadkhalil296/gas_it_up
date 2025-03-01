import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'order_details.dart';

class OrdersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
                child: Text('My Orders',style: Theme.of(context).textTheme.headlineLarge,textAlign: TextAlign.center,)),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('orders') .where("user_id", isEqualTo: user!.uid) // Filter by user ID
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No orders found"));
                  }
              
                  var orders = snapshot.data!.docs.map((doc) {
                    return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
                  }).toList();
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      var order = orders[index];
              
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreen(order: order),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order ID: ${order['id']}", style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.bold)),
                              // if (order.containsKey('created_at'))
                                Text("Date: ${order['created_at'].toString().split(' ')[0]}", style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
