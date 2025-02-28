import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/order/get_credit_card.dart';
import 'package:mechanic_services/widgets/selectable_field.dart';

import '../../services/AuthService.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';

class GetPaymentMethod extends StatefulWidget {
  const GetPaymentMethod({super.key});

  @override
  State<GetPaymentMethod> createState() => _GetPaymentMethodState();
}

class _GetPaymentMethodState extends State<GetPaymentMethod> {

  bool isOnDelivery = false;
  bool isCreditCard = false;

  String paymentMethod = '';

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
                  Icon(Icons.payment,color: Colors.white, size: 30,),
                  SizedBox(width: 20),
                  Text('Payment method',style: Theme.of(context).textTheme.headlineLarge)
                ]
            ),
            
            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isOnDelivery = !isOnDelivery;
                      isCreditCard = false;
                      paymentMethod = isOnDelivery ? 'on delivery' : '';
                    });
      },
                  child: SelectableField(
                    isSelected: isOnDelivery,
                      text1: 'on delivery'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isCreditCard = !isCreditCard;
                      isOnDelivery = false;
                      paymentMethod = isCreditCard ? 'credit card' : '';
                    });
                  },
                  child: SelectableField(
                      isSelected: isCreditCard,
                      text1: 'credit card'),
                ),

              ]
            ),



            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomBackButton(),
                  CustomNextButton(onPressed: () async{
                    if(paymentMethod == ''){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('select a payment method')));
                    return;
                    }

                    await LocalStorageService().save('payment_method',paymentMethod);
                    if(isCreditCard){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetCreditCard()));
                      return;
                    }
                    LocalStorageService _service = LocalStorageService();
                    String orderJsonString = await _service.get('order');
                    String city = await _service.get('city');
                    String street = await _service.get('street');
                    bool success = await FirebaseService.insertInto('orders',{
                      'Service' : 'Car Accessories',
                      'order' :orderJsonString,
                      'city' : city,
                      'street' : street,
                      'payment_method' : 'on delivery',


                      'user_id': await AuthService.getCurrentUserId()!,
                      'created_at' : DateTime.now().toString()

                    });
                    if(success){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('order submitted successfully'),));
                      Navigator.popUntil(context, ModalRoute.withName('/home'));

                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('could not submit the order at the moment'),));

                    }
                  })

                ]
            ),
          ]
        )
      ),
    );
  }
}
