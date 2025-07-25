import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/back_button.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      QuerySnapshot userSnapshot = await _firestore.collection('users').get();
      setState(() {
        _users = userSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
      _fetchUsers(); // Refresh the list
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user')),
      );
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
                    'Manage Users',
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: _users.isEmpty
                          ? Center(child: Text('No users found'))
                          : ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                return Card(
                                  color: Color.fromRGBO(16, 56, 127, 0.8),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        user['username']?[0]?.toUpperCase() ?? 'U',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    title: Text(
                                      user['username'] ?? 'Unknown User',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      user['email'] ?? 'No email',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deleteUser(user['id']),
                                    ),
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
} 