import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/input_field.dart';

import '../../services/AuthService.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';

class GetCreditCard extends StatefulWidget {
  const GetCreditCard({super.key});

  @override
  State<GetCreditCard> createState() => _GetCreditCardState();
}

class _GetCreditCardState extends State<GetCreditCard> {
  
  final cardNumberController = TextEditingController();
  final expirationDateController = TextEditingController();
  final secretCodeController = TextEditingController();
  DateTime? _selectedDate;
  String? _errorText;
  final _formKey = GlobalKey<FormState>();



  void _validateDate() {
    if (_selectedDate != null) {
      if (_selectedDate!.isBefore(DateTime.now())) {
        setState(() {
          _errorText = 'Expiry date cannot be in the past';
        });
      } else {
        setState(() {
          _errorText = null;
        });
      }
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked= await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Set the first selectable date to today
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _validateDate(); // Validate the date after selection
        _errorText == null? expirationDateController.text = '${picked.toLocal()}'.split(' ')[0] :
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorText!)));

      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment,color: Colors.white, size: 30,),
                    SizedBox(width: 20),
                    Text('Credit Card',style: Theme.of(context).textTheme.headlineLarge,)
                  ]
              ),

              Column(
                children: [
                  InputField(
                    validator: (value){
                      if(value == null || value == ''){
                        return 'card number cannot be empty';
                      }
                      try{
                        int temp = int.parse(value);
                      }catch(e){
                        return 'invalid card number';
                      }
                    },
                    controller: cardNumberController,
                      hintText: 'card number'
                  ),
                  SizedBox(height: 20),

                  InkWell(
                    onTap: () async{
                     await _selectDate(context);
                    },
                    child: InputField(

                        readOnly: true,
                        controller: expirationDateController,
                        hintText: 'expiration date'
                        ),
                        ),
                        SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text("Pick a Date"),
                  ),
                  SizedBox(height: 20),
                        InputField(
                        validator: (value){
                        if(value == null || value == ''){
                        return 'secret code cannot be empty';
                        }

                        },
                        controller: secretCodeController,
                        hintText: 'secret code'
                        ),
                        ]
                        ),


                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        CustomBackButton(),
                        CustomNextButton(onPressed: () async{
                        if(_formKey.currentState!.validate()){
                        if(_selectedDate == null){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please enter expiry date'),));
                        return;
                        }
                        LocalStorageService _service = LocalStorageService();
                        String orderJsonString = await _service.get('order');
                        String city = await _service.get('city');
                        String street = await _service.get('street');
                        String paymentMethod = await _service.get('payment_method');

                        String secretCode = secretCodeController.text.trim();
                        String cardNumber = cardNumberController.text.trim();

                        bool success = await FirebaseService.insertInto('orders',{
                        'Service' : 'Car Accessories',
                        'order' :orderJsonString,
                        'city' : city,
                        'street' : street,
                        'payment_method' : paymentMethod,
                        'expiry_date' : _selectedDate.toString(),
                        'secret_code' : secretCode,
                        'card_number' : cardNumber,

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
                        // if(paymentMethod == ''){
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('select a payment method'));
                        //       return;
                        //   }
                        //
                        //       await LocalStorageService().save('payment_method',paymentMethod);
                        //
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetCredit()));
                        }
    )
          
                  ]

              ),
            ],
          ),
        ),
      )
    );
  }
}
