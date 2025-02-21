import 'package:flutter/material.dart';

import '../../../services/AuthService.dart';
import '../../../services/firebase_service.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/next_button.dart';

TextEditingController quantityController = new TextEditingController();
TextEditingController totalPriceController = new TextEditingController();
class FuelPrice extends StatefulWidget {
  final String provider;
  final String fuelType;
  final double price;
  const FuelPrice({super.key,required this.provider, required this.price,required this.fuelType});

  @override
  State<FuelPrice> createState() => _FuelPriceState();
}

class _FuelPriceState extends State<FuelPrice> {
  double totalPrice= 0;
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:MainAxisAlignment.spaceAround,
          children: [
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage('assets/images/fuel_icon_white.png')),
                  SizedBox(width: 20),
                  Text('Fuel Delivery',style: Theme.of(context).textTheme.headlineLarge)
                ]
            ),

            Column(
              children: [
                Image(image: AssetImage('assets/images/fuel.png')),
                SizedBox(height: 20),
                Text('Enter the quantity in Liters:',style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 20),

                InputField(
                  hintText: 'Quantity',
                    inputType: TextInputType.number,
                    controller: quantityController,
                    onChanged: (value) {

                      try{

                        if(value == null) return ;
                        double intValue = double.parse(value);
                        if(intValue < 0) return ;

                        print("totalPrice $totalPrice");
                        print("quNTITYYYY ${quantityController.text.trim()}");
                        double quantity = double.parse(value);
                        print("quantity $quantity");
                        double newTotal =  quantity * widget.price;
                        print("new total $newTotal");
                        totalPrice = newTotal;
                        setState(() {
                          totalPriceController.text = 'Total: ' + newTotal.toString() + '\$';
                        });

                      }
                      catch(e){
                        totalPrice = 0;
                        return ;
                      }
                    },
                  // validator: (value){
                  //   if(value == null) return 'please select quantity';
                  //   try{
                  //     int intValue = int.parse(value);
                  //     if(intValue <=0) return 'invalid value';
                  //     return null;
                  //   }
                  //   catch(e){
                  //     return 'quantity must be a number';
                  //   }
                  // }
                )
              ]
            ),


            InputField(
              hintText: 'Total',
              controller: totalPriceController,
              readOnly:  false
            ),


            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomBackButton(),
                  CustomNextButton(onPressed: () async{
                    try{
                      int quantity = int.parse(quantityController.text.trim());
                      print("total $totalPrice");
                      print("quanity $quantity");
                      if(totalPrice <= 0 || quantity <= 0){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid quantity or price'),));
                      }else{
                        bool success = await FirebaseService.insertInto('orders',{
                          'Service' : 'Fuel Delivery',
                          'Provider' : this.widget.provider,
                          'Fuel Type' : this.widget.fuelType,
                          'Quantity' : quantity.toString() + ' Liters',
                          'Total' : totalPrice,
                          'user_id': await AuthService.getCurrentUserId()!,
                          'created_at' : DateTime.now().toString()

                        });
                        if(success){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('order submitted successfully'),));
                          Navigator.popUntil(context, ModalRoute.withName('/home'));

                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('could not submit the order at the moment'),));

                        }
                      }
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid quantity or price'),));

                    }

                  })

                ]
            )



          ]
        )
      )
    );
  }
}
