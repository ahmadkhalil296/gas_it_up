import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/back_button.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isEditing = false;

  // Controllers for user info
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);

    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        firstNameController.text = data['firstName'] ?? '';
        lastNameController.text = data['familyName'] ?? '';
        usernameController.text = data['username'] ?? '';
        idController.text = uid;
        emailController.text = data['email'] ?? '';
        phoneNumberController.text = data['phoneNumber'] ?? '';
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveUserData() async {
    setState(() => _isLoading = true);

    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update({
        'firstName': firstNameController.text,
        'familyName': lastNameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
      });

      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      print('Error saving user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }

    setState(() => _isLoading = false);
  }

  Widget _buildInfoRow(
      String type, TextEditingController controller, IconData icon,
      {bool isEditable = false}) {
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
                    'Account Info',
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
                          Icons.person,
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
                  _buildInfoRow(
                      'First Name', firstNameController, Icons.person_outline,
                      isEditable: true),
                  _buildInfoRow(
                      'Last Name', lastNameController, Icons.person_outline,
                      isEditable: true),
                  _buildInfoRow('Username', usernameController, Icons.person),
                  _buildInfoRow('ID', idController, Icons.credit_card),
                  _buildInfoRow('Email', emailController, Icons.email,
                      isEditable: true),
                  _buildInfoRow(
                      'Phone Number', phoneNumberController, Icons.phone,
                      isEditable: true),
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
                              _saveUserData();
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
