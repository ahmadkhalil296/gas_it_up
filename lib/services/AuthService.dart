import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import 'local_storage_service.dart';

/// Service class that handles all authentication-related operations
/// Including sign in, sign up, and user management
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up
  Future<User?> signUp(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
        await LocalStorageService().saveUser(userModel);
      }
      return user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  /// Signs in a user with their username and password
  /// First retrieves the user's email from Firestore using their username
  /// Then attempts to sign in with Firebase Auth
  /// Returns a UserModel if successful, null otherwise
  Future<UserModel?> signIn(String username, String password) async {
    try {
      // First get the email from Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No user found with this username");
        return null;
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      final email = userData['email'] as String?;

      if (email == null) {
        print("No email found for this user");
        return null;
      }

      // Sign in with email and password
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user != null) {
        // Get the user data again to ensure we have the latest
        final userDoc = await _firestore
            .collection('users')
            .doc(authResult.user!.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null) {
            final userModel = UserModel.fromMap(userData);
            await LocalStorageService().saveUser(userModel);
            return userModel;
          }
        }
      }
      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  /// Signs out the current user
  /// Clears local storage and Firebase auth session
  Future<void> signOut() async {
    try {
      // Clear all local storage data first
      await LocalStorageService().clearUser();

      // Sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
      rethrow;
    }
  }

  /// Gets the current user's ID from Firebase Auth
  /// Returns null if no user is signed in
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Gets the current user's username from Firestore
  /// Returns null if no user is signed in or username not found
  Future<String?> getCurrentUsername() async {
    try {
      String? uid = getCurrentUserId();
      if (uid != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          return userData['username'] as String?;
        }
      }
      return null;
    } catch (e) {
      print("Error getting username: $e");
      return null;
    }
  }
}
