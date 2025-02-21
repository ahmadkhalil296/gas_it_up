import 'package:mechanic_services/models/vehicule_info.dart';

class UserModel{
  String firstName;
  String familyName;
  String username;
  String email;
  String phoneNumber;
  String password;
  VehicleInfo vehicleInfo;

  UserModel({
    required this.firstName,
    required this.familyName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.vehicleInfo
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'familyName': familyName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'vehicleInfo': vehicleInfo.toMap(),
      'createdAt': DateTime.now().toString(),
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'],
      familyName: map['familyName'],
      username: map['username'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      password: '', // Password is not stored directly for security
      vehicleInfo: VehicleInfo.fromMap(map['vehicleInfo']),
    );
  }
}