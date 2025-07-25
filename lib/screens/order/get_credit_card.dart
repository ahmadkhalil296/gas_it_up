import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/input_field.dart';
import 'package:mechanic_services/screens/order/order_confirmation.dart';
import 'dart:convert';

import '../../services/AuthService.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';

class GetCreditCard extends StatefulWidget {
  final Map<String, dynamic>? orderData;
  
  const GetCreditCard({super.key, this.orderData});

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
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _validateDate();
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
                    hintText: 'card number',
                    obscureText: true,
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
                      if(value.length != 3){
                        return 'secret code must be 3 digits';
                      }
                      try{
                        int.parse(value);
                      }catch(e){
                        return 'secret code must contain only numbers';
                      }
                      return null;
                    },
                    controller: secretCodeController,
                    hintText: 'secret code (3 digits)',
                    obscureText: true,
                    inputType: TextInputType.number,
                    onChanged: (value) {
                      if (value == null) return;
                      
                      String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                      
                      if (digitsOnly.length > 3) {
                        digitsOnly = digitsOnly.substring(0, 3);
                      }
                      
                      if (digitsOnly != value) {
                        secretCodeController.text = digitsOnly;
                        secretCodeController.selection = TextSelection.fromPosition(
                          TextPosition(offset: digitsOnly.length),
                        );
                      }
                    },
                  ),
                ],
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

                      // Parse the order to get the actual service type and details
                      dynamic orderDataParsed = jsonDecode(orderJsonString);
                      Map<String, dynamic> orderData;
                      
                      // Handle both Map and List cases
                      if (orderDataParsed is List) {
                        orderData = orderDataParsed.isNotEmpty ? Map<String, dynamic>.from(orderDataParsed[0]) : {};
                      } else {
                        orderData = Map<String, dynamic>.from(orderDataParsed);
                      }

                      // Prepare the complete order data
                      Map<String, dynamic> completeOrderData = {
                        ...orderData,
                        'city': jsonDecode(city),
                        'street': jsonDecode(street),
                        'payment_method': paymentMethod,
                        'expiry_date': _selectedDate.toString(),
                        'secret_code': secretCode,
                        'card_number': cardNumber,
                        'user_id': await AuthService().getCurrentUserId()!,
                        'created_at': DateTime.now().toString()
                      };

                      // Navigate to confirmation screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderConfirmationScreen(
                            orderData: completeOrderData,
                          ),
                        ),
                      );
                    }
                  })
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
