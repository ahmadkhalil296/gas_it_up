import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/selectable_field.dart';

class CarWash extends StatefulWidget {
  const CarWash({super.key});

  @override
  State<CarWash> createState() => _CarWashState();
}

class _CarWashState extends State<CarWash> {

  bool isExteriorSelected = false;
  bool isInteriorSelected = false;
  bool isFullSelected = false;
  
  String selectedService = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: 40,bottom: 20, left:20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image(image: AssetImage('assets/images/vehicule.jpg'),fit: BoxFit.cover,)),
                ),
                SizedBox(width: 20),
                Text('Car wash',style: Theme.of(context).textTheme.headlineLarge)
              ]
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
      setState(() {
        isExteriorSelected = !isExteriorSelected;
        isInteriorSelected = false;
        isFullSelected = false;
        selectedService =isExteriorSelected ? 'Exterior Wash' : '';
      });               
    },
                    child: SelectableField(
                        isSelected: isExteriorSelected,
                        text1: 'Exterior Wash',
                        text2: '3\$'
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isInteriorSelected = !isInteriorSelected;
                        isExteriorSelected = false;
                        isFullSelected = false;
                        selectedService =isInteriorSelected ? 'Interior Wash' : '';
                      });
                    },
                    child: SelectableField(
                        isSelected: isInteriorSelected,
                        text1: 'Interior Wash',
                        text2: '3\$'
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isFullSelected = !isFullSelected;
                        isExteriorSelected = false;
                        isInteriorSelected = false;
                        selectedService =isFullSelected ? 'Full Wash' : '';
                      });
                    },
                    child: SelectableField(
                        isSelected: isFullSelected,
                        text1: 'Full Wash',
                        text2: '3\$'
                    ),
                  ),
                ]
              ),
            ),


            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomBackButton(),
                    CustomNextButton(onPressed: () async{
                      try{

                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid quantity or price'),));

                      }

                    })

                  ]
              ),
            )

          ]
        )
      )
    );
  }
}
