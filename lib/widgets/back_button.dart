import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton.icon(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_sharp, size: 25, color: Colors.white),
      label: Text(
        "Back",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), // Bold text
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(8, 174, 234, 0.53), // Button color in RGBA
        // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded edges
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
