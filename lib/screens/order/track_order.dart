import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/AuthService.dart';
import 'package:mechanic_services/screens/home.dart';
import 'package:mechanic_services/widgets/back_button.dart';

class TrackOrderScreen extends StatefulWidget {
  final String? orderId;

  const TrackOrderScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final TextEditingController _orderIdController = TextEditingController();
  Map<String, dynamic>? orderData;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    // Initialize tracking immediately
    _trackOrder();
  }

  Future<void> _trackOrder() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      String? userId = AuthService().getCurrentUserId();
      if (userId == null) {
        setState(() {
          error = 'User not authenticated';
          isLoading = false;
        });
        return;
      }

      // If no orderId is provided, get the most recent order
      if (widget.orderId == null) {
        try {
          // First get all orders for the user
          QuerySnapshot orderQuery = await FirebaseFirestore.instance
              .collection('orders')
              .where('user_id', isEqualTo: userId)
              .get();

          if (orderQuery.docs.isEmpty) {
            setState(() {
              error = 'No orders found';
              isLoading = false;
            });
            return;
          }

          // Sort the documents by timestamp manually
          var docs = orderQuery.docs;
          docs.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            var aTime = aData['timestamp'] ?? 0;
            var bTime = bData['timestamp'] ?? 0;
            return bTime.compareTo(aTime); // Descending order
          });

          // Get the most recent order
          DocumentSnapshot mostRecentOrder = docs.first;
          Map<String, dynamic> data =
              mostRecentOrder.data() as Map<String, dynamic>;
          data['orderId'] = mostRecentOrder.id; // Store the document ID

          setState(() {
            orderData = data;
            isLoading = false;
            print('Most recent order loaded: $orderData');
          });
          return;
        } catch (e) {
          print('Error fetching orders: $e');
          setState(() {
            error = 'Error fetching orders. Please try again.';
            isLoading = false;
          });
          return;
        }
      }

      // If orderId is provided, get that specific order
      DocumentSnapshot orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (!orderDoc.exists) {
        setState(() {
          error = 'Order not found';
          isLoading = false;
        });
        return;
      }

      Map<String, dynamic> data = orderDoc.data() as Map<String, dynamic>;
      data['orderId'] = orderDoc.id; // Store the document ID

      // Verify the order belongs to the current user
      if (data['user_id'] != userId) {
        setState(() {
          error = 'Order not found';
          isLoading = false;
        });
        return;
      }

      setState(() {
        orderData = data;
        isLoading = false;
        print('Order Data loaded: $orderData');
      });
    } catch (e) {
      print('Error tracking order: $e');
      setState(() {
        error = 'Error tracking order: $e';
        isLoading = false;
      });
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '\$0.00';

    // If price is already a number
    if (price is num) {
      return '\$${price.toStringAsFixed(2)}';
    }

    // If price is a string, try to parse it
    if (price is String) {
      try {
        double numPrice = double.parse(price);
        return '\$${numPrice.toStringAsFixed(2)}';
      } catch (e) {
        return '\$0.00';
      }
    }

    return '\$0.00';
  }

  Widget _buildOrderStatus() {
    if (orderData == null) return SizedBox();

    String status = orderData!['status'] ?? 'pending';
    int currentStep = _getStepFromStatus(status);

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 150,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF1A1F37),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimelineItem(
                  icon: Icons.receipt_long,
                  title: 'Order Placed',
                  time: '11:45 PM',
                  location: 'Lebanon, Tripoli',
                  isActive: currentStep >= 0,
                  isFirst: true,
                ),
                _buildTimelineItem(
                  icon: Icons.local_shipping,
                  title: 'Sent From Tripoli',
                  time: '11:50 PM',
                  location: '',
                  isActive: currentStep >= 1,
                ),
                _buildTimelineItem(
                  icon: Icons.delivery_dining,
                  title: 'On the way',
                  time: '12:00 PM',
                  location: '',
                  isActive: currentStep >= 2,
                  isLast: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Driver Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1F37),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(0xFF7B61FF).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF7B61FF),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fadi Omari',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your Driver',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '81163848',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add call functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7B61FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Call Driver'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Add View Map Button
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                print('Button pressed');
                // Use the document ID stored in orderData
                String? orderId = orderData?['orderId'];
                print('Order ID from data: $orderId');
                if (orderId != null) {
                  print('Navigating to map with order ID: $orderId');
                  Navigator.pushNamed(
                    context,
                    '/track_order_map',
                    arguments: orderId,
                  );
                } else {
                  print('Order ID is null');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Cannot track order: No order ID available'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7B61FF),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'View on Map',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String time,
    required String location,
    required bool isActive,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: Row(
        children: [
          if (!isFirst)
            Expanded(
              child: Container(
                height: 2,
                color:
                    isActive ? Color(0xFF7B61FF) : Colors.grey.withOpacity(0.3),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isActive
                      ? Color(0xFF7B61FF)
                      : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              if (location.isNotEmpty) ...[
                SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
          if (!isLast)
            Expanded(
              child: Container(
                height: 2,
                color:
                    isActive ? Color(0xFF7B61FF) : Colors.grey.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  int _getStepFromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 0;
      case 'confirmed':
        return 1;
      case 'in_progress':
        return 2;
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Track Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    if (error != null)
                      Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                error!,
                                style: TextStyle(color: Colors.red[900]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (orderData != null)
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildOrderStatus(),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: CustomBackButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    super.dispose();
  }
}
