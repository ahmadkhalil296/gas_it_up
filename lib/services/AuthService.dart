import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import 'local_storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up
  Future<User?> signUp(UserModel userModel) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: userModel.email, password: userModel.password);
      User? user = userCredential.user;

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(user?.uid).set(userModel.toMap());
      await LocalStorageService().saveUser(userModel);

      return user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Login
  Future<UserModel?> signIn(String username, String password) async {
    try {
      // Get user data from Firestore using username
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print("User not found");
        return null;
      }

      var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      // Authenticate with Firebase using email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userData['email'],
        password: password,
      );

      if (userCredential.user != null) {
        await LocalStorageService().saveUser(UserModel.fromMap(userData));
        return UserModel.fromMap(userData);
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return null;
  }

  // Logout
  Future<void> signOut() async {
    await LocalStorageService().clearUser();
    await _auth.signOut();
  }

  static String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns null if no user is logged in
  }
}
