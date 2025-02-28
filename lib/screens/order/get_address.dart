import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/order/get_payment_method.dart';
import 'package:mechanic_services/widgets/input_field.dart';

import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';


class GetAddress extends StatefulWidget {
  const GetAddress({super.key});

  @override
  State<GetAddress> createState() => _GetAddressState();
}

class _GetAddressState extends State<GetAddress> {
final streetController = TextEditingController();
final cityController = TextEditingController();


String? _validate(String? value){
  if(value == null || value == ''){
    return 'value cannot be empty';
  }
  return null;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings,color: Colors.white, size: 30,),
                  SizedBox(width: 20),
                  Text('Car Accessories',style: Theme.of(context).textTheme.headlineLarge)
                ]
            ),

            Column(
              children: [
                InputField(
                  validator: _validate,
                  controller: cityController,
                    hintText: 'City'
                ),
                SizedBox(height: 20),
                InputField(
                    validator: _validate,
                  controller: streetController,
                    hintText: 'Street'
                ),
              ]
            ),


            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomBackButton(),
                  CustomNextButton(onPressed: () async{

                    String? city = cityController.text.trim();
                    String? street = streetController.text.trim();

                    if(city == null || street == null || city == '' || street == ''){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please fill street and city'),));
                      return;
                    }
                    await LocalStorageService().save('city',jsonEncode(city));
                    await LocalStorageService().save('street',jsonEncode(street));

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetPaymentMethod()));
                  })

                ]
            ),
          ]
        ),
      )
    );
  }
}
