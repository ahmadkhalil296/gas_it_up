import 'package:flutter/material.dart';

class CustomNextButton extends StatelessWidget {

  final VoidCallback onPressed;
  const CustomNextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensures button size fits content
        children: [
           // Arrow Icon
          // Space between icon and text
          const Text("Next",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 25, color: Colors.white),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(8, 174, 234, 1), // Button color in RGBA
        // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded edges
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
