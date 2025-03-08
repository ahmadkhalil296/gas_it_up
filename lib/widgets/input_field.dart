import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final Color backgroundColor;
  final TextEditingController? controller;
  final TextInputType inputType;
  final bool obscureText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const InputField({
    Key? key,
    required this.hintText,
    this.icon,
    this.backgroundColor = const Color.fromRGBO(8, 174, 234, 1), // Default color
    this.controller,
    this.inputType = TextInputType.text, // Default input type
    this.obscureText = false, // Default not obscured
    this.validator,
    this.onChanged,
    this.readOnly = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(8, 174, 234, 1), // Background color
        borderRadius: BorderRadius.circular(30), // Rounded edges
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          if(icon != null) Icon(icon, color: Colors.white, size: 24), // Icon
          if(icon != null) SizedBox(width: 10), // Spacing
          Expanded(
            child: TextFormField(
              readOnly: readOnly,
              keyboardType: inputType, // Input type
              obscureText: obscureText, // Hide text for passwords
              controller: controller,
              validator: validator,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value); // Call the passed function
                }
              },
              decoration: InputDecoration(
                hintText: hintText,

                hintStyle: TextStyle(color: Colors.white), // Hint text styling
                border: InputBorder.none, // Removes underline
              ),
              style: TextStyle(color: Colors.white), // Input text styling
            ),
          ),
        ],
      ),
    );
  }
}