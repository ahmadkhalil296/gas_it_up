import 'package:flutter/material.dart';

class SelectableRadioButton extends StatefulWidget {
  bool isSelected = false;
  String text;
   SelectableRadioButton({super.key, this.isSelected = false,required this.text});

  @override
  State<SelectableRadioButton> createState() => _SelectableRadioButtonState();
}

class _SelectableRadioButtonState extends State<SelectableRadioButton> {



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: 120,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child:  Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
            children: [
              if(this.widget.isSelected) Icon(Icons.check,color: Colors.black),
              Center(
                child: Text(widget.text,textAlign: TextAlign.center,style: TextStyle(
                  color: Colors.black ,
                ),),
              ),
            ]
        ),
      ),
    );
  }
}
