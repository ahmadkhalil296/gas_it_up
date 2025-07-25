import 'package:flutter/material.dart';


class SelectableField extends StatefulWidget {

  bool isSelected = false;
  String text1;
  String? text2;

   SelectableField({super.key, this.isSelected = false,required this.text1,this.text2});

  @override
  State<SelectableField> createState() => _SelectableFieldState();
}

class _SelectableFieldState extends State<SelectableField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: this.widget.isSelected
              ? Colors.white
              : Color.fromRGBO(8, 174, 234, 0.89),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
            mainAxisAlignment: this.widget.text2 == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [

              Row(
                  children: [
                    if(this.widget.isSelected) Icon(Icons.check,color: Colors.black),
                    Text(widget.text1,style: TextStyle(
                      color: this.widget.isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ]
              ),
              if(widget.text2 != null)
              Text(widget.text2!,style: TextStyle(
                color: this.widget.isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),)
            ]
        )
    );
  }
}
