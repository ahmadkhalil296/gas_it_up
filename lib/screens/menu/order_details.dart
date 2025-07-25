import 'package:flutter/material.dart';
import 'dart:convert';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  late final Map<String, dynamic> orderDetails;

  OrderDetailsScreen({required this.order}) {
    orderDetails = {};
    if (order.containsKey('order')) {
      try {
        orderDetails = jsonDecode(order['order']);
      } catch (_) {}
    }
  }

  String _maskCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) return cardNumber;
    return '${'*' * (cardNumber.length - 4)}${cardNumber.substring(cardNumber.length - 4)}';
  }

  String _maskSecretCode(String secretCode) {
    return '*' * secretCode.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with subtle animation
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
                  child: Center(
                    child: Text(
                      'Order Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Order ID and Total Card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue[600]!,
                        Colors.blue[800]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
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
                      Row(
                        children: [
                          Icon(Icons.receipt_long, color: Colors.white70, size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Order ID: ${order['id']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.white70, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Total = \$${_getOrderTotal()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Payment Information Section
                _buildSectionTitle('Payment Information', Icons.payment),
                SizedBox(height: 16),
                _buildSectionContainer([
                  _buildInfoRow('Payment Method:', 
                    order['payment_method'] == 'credit card' ? 'Credit Card' : 'On Delivery', 
                    order['payment_method'] == 'credit card' ? Icons.credit_card : Icons.local_shipping),
                  if (order['payment_method'] == 'credit card') ...[
                    SizedBox(height: 16),
                    _buildInfoRow('Card Number:', _maskCardNumber(order['card_number'] ?? ''), Icons.credit_card),
                    SizedBox(height: 16),
                    _buildInfoRow('Expiry Date:', order['expiry_date']?.toString().split(' ')[0] ?? '', Icons.calendar_today),
                    SizedBox(height: 16),
                    _buildInfoRow('Secret Code:', '***', Icons.security),
                  ],
                ]),
                SizedBox(height: 32),

                // Order Information Section
                _buildSectionTitle('Order Information', Icons.info_outline),
                SizedBox(height: 16),
                _buildSectionContainer([
                  _buildInfoRow('Service:', orderDetails['Service'] ?? order['Service'] ?? '', Icons.miscellaneous_services),
                  if (orderDetails['type'] != null || order['type'] != null) ...[
                    SizedBox(height: 16),
                    _buildInfoRow('Type:', orderDetails['type'] ?? order['type'] ?? '', Icons.category),
                  ],
                  if ((orderDetails['Service'] ?? order['Service']) == 'Tire Change' && 
                      (orderDetails['tire'] != null || order['tire'] != null)) ...[
                    SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        Map<String, dynamic> tireInfo = {};
                        try {
                          String tireJson = orderDetails['tire'] ?? order['tire'];
                          tireInfo = jsonDecode(tireJson);
                        } catch (_) {}
                        return Column(
                          children: [
                            _buildInfoRow('Tire Size:', tireInfo['size']?.toString() ?? '', Icons.tire_repair),
                          ],
                        );
                      },
                    ),
                  ],
                  if ((orderDetails['Service'] ?? order['Service']) == 'Car Accessories' &&
                      (orderDetails['items'] != null || order['items'] != null)) ...[
                    SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        List<dynamic> items = [];
                        try {
                          items = orderDetails['items'] ?? order['items'];
                        } catch (_) {}
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Items:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            ...items.map((item) => Padding(
                              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                              child: Text(
                                '${item['quantity']}x ${item['name']} (\$${item['price']})',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )).toList(),
                          ],
                        );
                      },
                    ),
                  ],
                  SizedBox(height: 24),
                  _buildSubsectionTitle('Address', Icons.location_on),
                  SizedBox(height: 16),
                  _buildInfoRow('City:', order['city'] ?? '', Icons.location_city),
                  SizedBox(height: 12),
                  _buildInfoRow('Street:', order['street'] ?? '', Icons.streetview),
                ]),
                SizedBox(height: 32),

                // Back Button
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getOrderTotal() {
    // Try to get the price from all possible locations
    if (order['Total'] != null) return order['Total'].toString();
    if (order['price'] != null) return order['price'].toString();
    if (orderDetails['Total'] != null) return orderDetails['Total'].toString();
    if (orderDetails['price'] != null) return orderDetails['price'].toString();
    
    // Handle tire change specific case
    if ((orderDetails['Service'] ?? order['Service']) == 'Tire Change' && 
        (orderDetails['tire'] != null || order['tire'] != null)) {
      try {
        String tireJson = orderDetails['tire'] ?? order['tire'];
        Map<String, dynamic> tireInfo = jsonDecode(tireJson);
        if (tireInfo['price'] != null) {
          // Remove the $ symbol if present
          return tireInfo['price'].toString().replaceAll('\$', '');
        }
      } catch (_) {}
    }
    
    return '0';
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubsectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF0D1B3E).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
