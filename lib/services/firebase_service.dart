import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService{
  static Future<bool> insertInto(String collection, Map<String, dynamic> data) async{
    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection(collection).add(data);
      print("Document added with ID: ${docRef.id}");

      return true;
    } catch (error) {
      print("Error adding document: $error");
      return false;
    }
  }
}