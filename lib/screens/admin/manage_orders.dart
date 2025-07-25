import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/back_button.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      QuerySnapshot orderSnapshot = await _firestore.collection('orders').get();
      setState(() {
        _orders = orderSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated successfully')),
      );
      _fetchOrders(); // Refresh the list
    } catch (e) {
      print('Error updating order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status')),
      );
    }
  }

  String _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'processing':
        return '#1E90FF'; // Blue
      case 'completed':
        return '#32CD32'; // Green
      case 'cancelled':
        return '#FF0000'; // Red
      default:
        return '#808080'; // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Manage Orders',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: _orders.isEmpty
                          ? Center(child: Text('No orders found'))
                          : ListView.builder(
                              itemCount: _orders.length,
                              itemBuilder: (context, index) {
                                final order = _orders[index];
                                final status = order['status'] ?? 'pending';
                                final statusColor = _getStatusColor(status);
                                
                                return Card(
                                  color: Color.fromRGBO(16, 56, 127, 0.8),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ExpansionTile(
                                    title: Text(
                                      'Order #${order['id'].substring(0, 8)}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      'Service: ${order['Service'] ?? 'Unknown'}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Color(int.parse(statusColor.replaceAll('#', '0xFF'))),
                                      child: Text(
                                        status[0].toUpperCase(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Details:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Type: ${order['type'] ?? 'N/A'}',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              'Price: \$${order['price'] ?? '0'}',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              'Date: ${order['created_at'] ?? 'N/A'}',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Update Status:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              alignment: WrapAlignment.start,
                                              children: [
                                                _buildStatusButton(
                                                  'Pending',
                                                  '#FFA500',
                                                  () => _updateOrderStatus(order['id'], 'pending'),
                                                ),
                                                _buildStatusButton(
                                                  'Processing',
                                                  '#1E90FF',
                                                  () => _updateOrderStatus(order['id'], 'processing'),
                                                ),
                                                _buildStatusButton(
                                                  'Completed',
                                                  '#32CD32',
                                                  () => _updateOrderStatus(order['id'], 'completed'),
                                                ),
                                                _buildStatusButton(
                                                  'Cancelled',
                                                  '#FF0000',
                                                  () => _updateOrderStatus(order['id'], 'cancelled'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: const CustomBackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String text, String colorCode, VoidCallback onPressed) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(int.parse(colorCode.replaceAll('#', '0xFF'))),
          padding: EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
} 