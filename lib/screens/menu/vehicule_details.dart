import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VehicleInfoScreen extends StatefulWidget {
  @override
  _VehicleInfoScreenState createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isEditing = false;
  bool _isLoading = false;

  // Controllers for vehicle info
  TextEditingController typeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVehicleData();
  }

  Future<void> _fetchVehicleData() async {
    setState(() => _isLoading = true);

    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        var vehicleInfo = data['vehicleInfo'] as Map<String, dynamic>? ?? {};

        typeController.text = vehicleInfo['type'] ?? '';
        modelController.text = vehicleInfo['model'] ?? '';
        colorController.text = vehicleInfo['color'] ?? '';
        plateNumberController.text = vehicleInfo['plateNumber'].toString();
        yearController.text = vehicleInfo['year'].toString();
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
          'type': typeController.text,
          'model': modelController.text,
          'color': colorController.text,
          'plateNumber': int.parse(plateNumberController.text),
          'year': int.parse(yearController.text),
        },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.car_crash_outlined,color: Colors.white, size: 30,),
                  SizedBox(width: 20),
                  Text('Vehicule Info',style: Theme.of(context).textTheme.headlineLarge)
                ]
            ),
            _buildTextField('Type', typeController),
            _buildTextField('Model', modelController),
            _buildTextField('Color', colorController),
            _buildTextField('Plate Number', plateNumberController, isNumber: true),
            _buildTextField('Year', yearController, isNumber: true),
            SizedBox(height: 20),
            _isEditing
                ? ElevatedButton(onPressed: _saveVehicleData, child: Text('Save'))
                : ElevatedButton(onPressed: () => setState(() => _isEditing = true), child: Text('Edit')),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.white), // White text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white), // White label color
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      readOnly: !_isEditing,
    );
  }
}
