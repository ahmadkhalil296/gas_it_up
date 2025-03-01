import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/menu/vehicule_details.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isEditing = false;
  bool _isLoading = false;

  // Controllers for user info
  TextEditingController firstNameController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
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
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        firstNameController.text = data['firstName'] ?? '';
        familyNameController.text = data['familyName'] ?? '';
        usernameController.text = data['username'] ?? '';
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
        'familyName': familyNameController.text,
        'username': usernameController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person,color: Colors.white, size: 30,),
                      SizedBox(width: 20),
                      Text('Profile Info',style: Theme.of(context).textTheme.headlineLarge)
                    ]
                ),
                _buildTextField('First Name', firstNameController),
                _buildTextField('Family Name', familyNameController),
                _buildTextField('Username', usernameController),
                _buildTextField('Email', emailController, isEmail: true),
                _buildTextField('Phone Number', phoneNumberController, isPhone: true),
                SizedBox(height: 20),
                _isEditing
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveUserData,
                      child: Text('Save'),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() => _isEditing = false),
                      child: Text('Cancel'),
                    ),
                  ],
                )
                    : ElevatedButton(
                  onPressed: () => setState(() => _isEditing = true),
                  child: Text('Edit'),
                ),
                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isEmail = false, bool isPhone = false}) {
    return TextField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
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
      readOnly: !_isEditing || isEmail || isPhone,
    );
  }
}
