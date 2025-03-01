import 'package:flutter/material.dart';
import 'dart:convert';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                width: MediaQuery.of(context).size.width,
                child: Text('Order Details',style: Theme.of(context).textTheme.headlineLarge,textAlign: TextAlign.center,)),

            Text("Order ID: ${order['id']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ..._buildOrderDetails(order),
          ],
        ),
      ),
    );
  }

  /// Dynamically build widgets based on unknown JSON structure
  List<Widget> _buildOrderDetails(Map<String, dynamic> data) {
    List<Widget> widgets = [];

    data.forEach((key, value) {
      if (key == "id" || key == 'user_id') return; // Skip ID since it's already shown

      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text("${key.toString().replaceAll("_", " ")}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ));
     value =  key == 'created_at' ? value.toString().split(" ")[0] : value;
      widgets.add(_buildValueWidget(value));
    });

    return widgets;
  }

  /// Handles various data types (Strings, Lists, Maps)
  Widget _buildValueWidget(dynamic value) {
    if (value is String) {
      // Try parsing JSON if it's a JSON string
      try {
        var parsedJson = jsonDecode(value);
        if (parsedJson is List || parsedJson is Map<String, dynamic>) {
          return _buildValueWidget(parsedJson);
        }
      } catch (_) {}

      return Text(value.toString().replaceAll("\"", ''), style: TextStyle(fontSize: 18));
    }

    if (value is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value.map((item) => _buildValueWidget(item)).toList(),
      );
    }

    if (value is Map<String, dynamic>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: value.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(entry.key != 'image')
                Expanded(flex: 3, child: Text("${entry.key}:", style: TextStyle(fontWeight: FontWeight.bold))),
                  if(entry.key == 'price' && entry.key != 'image' && !entry.value.toString().contains('\$'))
                Expanded(flex: 5, child: _buildValueWidget(entry.value.toString() + ' \$' )),
                if((entry.key != 'price' && entry.key != 'image') || (entry.key == 'price' && entry.key != 'image' && entry.value.toString().contains('\$')))
                Expanded(flex: 5, child: _buildValueWidget(entry.value)),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Text(value.toString(), style: TextStyle(fontSize: 18));
  }
}
