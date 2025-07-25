import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/order/get_payment_method.dart';
import 'package:mechanic_services/screens/order/get_credit_card.dart';
import 'package:mechanic_services/services/firebase_service.dart';
import 'package:mechanic_services/screens/home.dart';
import 'package:mechanic_services/widgets/back_button.dart';
import 'package:mechanic_services/widgets/next_button.dart';
import 'package:mechanic_services/screens/order/track_order.dart';
import 'dart:convert';

class OrderConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;

  OrderConfirmationScreen({required this.orderData});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String _formatPrice(dynamic price) {
    if (price == null) return '\$0.00';

    // If price is already a number
    if (price is num) {
      return '\$${price.toStringAsFixed(2)}';
    }

    // If price is a string, try to parse it
    if (price is String) {
      try {
        // Remove any existing $ symbol and trim whitespace
        String cleanPrice = price.replaceAll('\$', '').trim();
        double numPrice = double.parse(cleanPrice);
        return '\$${numPrice.toStringAsFixed(2)}';
      } catch (e) {
        return '\$0.00';
      }
    }

    return '\$0.00';
  }

  String _getOrderTotal() {
    // Try to get the price from all possible locations
    if (widget.orderData['Total'] != null) return _formatPrice(widget.orderData['Total']);
    if (widget.orderData['price'] != null) return _formatPrice(widget.orderData['price']);
    
    // Calculate total from items if available
    if (widget.orderData['items'] != null) {
      try {
        double total = 0;
        List<dynamic> items = widget.orderData['items'];
        for (var item in items) {
          double itemPrice = double.parse(item['price'].toString().replaceAll('\$', ''));
          int quantity = int.parse(item['quantity'].toString());
          total += itemPrice * quantity;
        }
        return _formatPrice(total);
      } catch (e) {
        print('Error calculating total from items: $e');
      }
    }
    
    return '\$0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF0D47A1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with animation
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(width: 20),
                            Flexible(
                              child: Text(
                                'Order Confirmation',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Your order has been placed successfully',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      top: 0,
                    ),
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      top: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Order Details', Icons.receipt_long),
                        SizedBox(height: 16),
                        _buildOrderInfo(
                            'Service Type:',
                            widget.orderData['Service'] ?? '',
                            Icons.miscellaneous_services),
                        SizedBox(height: 16),
                        if (widget.orderData['items'] != null) ...[
                          _buildSectionTitle('Items', Icons.shopping_cart),
                          SizedBox(height: 12),
                          ...(widget.orderData['items'] as List)
                              .map((item) => Container(
                                    margin: EdgeInsets.only(
                                        left: 16.0, bottom: 8.0),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 20),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '${item['quantity']}x ${item['name']}',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _formatPrice(item['price']),
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          SizedBox(height: 16),
                        ],
                        _buildOrderInfo(
                            'Total Price:',
                            _getOrderTotal(),
                            Icons.attach_money),
                        SizedBox(height: 24),
                        _buildSectionTitle(
                            'Payment Information', Icons.payment),
                        SizedBox(height: 16),
                        _buildOrderInfo(
                            'Payment Method:',
                            widget.orderData['payment_method'] ?? '',
                            Icons.credit_card),
                        if (widget.orderData['payment_method'] ==
                            'credit card') ...[
                          SizedBox(height: 16),
                          _buildOrderInfo(
                              'Card Number:',
                              '**** **** **** ${widget.orderData['card_number'].substring(widget.orderData['card_number'].length - 4)}',
                              Icons.credit_card),
                          SizedBox(height: 16),
                          _buildOrderInfo(
                              'Expiry Date:',
                              widget.orderData['expiry_date'] ?? '',
                              Icons.calendar_today),
                          SizedBox(height: 16),
                          _buildOrderInfo(
                              'Secret Code:',
                              '***',
                              Icons.security),
                        ],
                        SizedBox(height: 24),
                        _buildSectionTitle(
                            'Delivery Address', Icons.location_on),
                        SizedBox(height: 16),
                        _buildOrderInfo(
                            'Address:',
                            '${widget.orderData['street']}, ${widget.orderData['city']}',
                            Icons.location_city),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[800], size: 24),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.grey[900],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to edit order
                  Navigator.pop(context);
                },
                icon: Icon(Icons.edit, size: 25, color: Colors.white),
                label: Text(
                  "Edit",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Submit order logic here
                  _submitOrder();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Confirm",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_circle, size: 25, color: Colors.white),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_sharp, size: 25, color: Colors.white),
            label: Text(
              "Back",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(8, 174, 234, 0.53),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _submitOrder() async {
    bool success = await FirebaseService.insertInto('orders', widget.orderData);
    if (success) {
      // Show success dialog with track order option
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(height: 16),
                Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'Your order has been placed successfully. You can track your order status.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                },
                child: Text('Homepage'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackOrderScreen(
                        orderId: widget.orderData['id'],
                      ),
                    ),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.location_on),
                label: Text('Track Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
