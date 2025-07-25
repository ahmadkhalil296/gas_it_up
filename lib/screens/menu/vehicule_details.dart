import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/back_button.dart';

class VehicleInfoScreen extends StatefulWidget {
  @override
  _VehicleInfoScreenState createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isEditing = false;

  // Controllers for vehicle info
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVehicleData();
  }

  Future<void> _fetchVehicleData() async {
    setState(() => _isLoading = true);

    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('vehicleInfo')) {
          var vehicleInfo = data['vehicleInfo'];
          plateNumberController.text =
              vehicleInfo['plateNumber']?.toString() ?? '';
          modelController.text = vehicleInfo['model'] ?? '';
          colorController.text = vehicleInfo['color'] ?? '';
          yearController.text = vehicleInfo['year']?.toString() ?? '';
          typeController.text = vehicleInfo['type'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching vehicle data: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveVehicleData() async {
    setState(() => _isLoading = true);

    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update({
        'vehicleInfo': {
          'plateNumber': plateNumberController.text,
          'model': modelController.text,
          'color': colorController.text,
          'year': yearController.text,
          'type': typeController.text,
        }
      });

      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehicle info updated successfully!')),
      );
    } catch (e) {
      print('Error saving vehicle data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update vehicle info')),
      );
    }

    setState(() => _isLoading = false);
  }

  Widget _buildInfoRow(
      String type, TextEditingController controller, IconData icon,
      {bool isEditable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyle(color: Colors.white, fontSize: 18),
              enabled: isEditable && _isEditing,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: type,
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Vehicle Info',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.directions_car,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  _buildInfoRow('Vehicle Type', typeController,
                      Icons.directions_car_filled),
                  _buildInfoRow('Model', modelController, Icons.model_training),
                  _buildInfoRow('Year', yearController, Icons.calendar_today),
                  _buildInfoRow('Color', colorController, Icons.color_lens),
                  _buildInfoRow(
                      'Plate Number', plateNumberController, Icons.credit_card),
                  SizedBox(height: 40),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(),
                        ElevatedButton(
                          onPressed: () {
                            if (_isEditing) {
                              _saveVehicleData();
                            } else {
                              setState(() => _isEditing = true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _isEditing ? 'Save' : 'Edit',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
