import 'package:flutter/material.dart';
import 'package:mechanic_services/screens/order/order_confirmation.dart';
import 'dart:convert';

import '../../services/AuthService.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';

class GetPaymentMethod extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const GetPaymentMethod({super.key, this.orderData});

  @override
  State<GetPaymentMethod> createState() => _GetPaymentMethodState();
}

class _GetPaymentMethodState extends State<GetPaymentMethod> {
  bool isOnDelivery = false;
  bool isCreditCard = false;
  String paymentMethod = '';

  // Credit card controllers
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Widget _buildCreditCardFields() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: isCreditCard ? null : 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: isCreditCard ? 1 : 0,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      prefixIcon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '**** **** **** ****',
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 19, // 16 digits + 3 spaces
                    onChanged: (value) {
                      if (value.isEmpty) return;

                      // Remove any non-digit characters from the input
                      String numbers = value.replaceAll(RegExp(r'\D'), '');

                      // Limit to 16 digits
                      if (numbers.length > 16) {
                        numbers = numbers.substring(0, 16);
                      }

                      // Add spaces after every 4 digits
                      List<String> chunks = [];
                      for (int i = 0; i < numbers.length; i += 4) {
                        int end = i + 4;
                        if (end > numbers.length) {
                          end = numbers.length;
                        }
                        chunks.add(numbers.substring(i, end));
                      }
                      String formatted = chunks.join(' ');

                      // Only update if the formatted text is different
                      if (formatted != value) {
                        // Calculate new cursor position
                        int cursorPosition = value.length;
                        if (value.endsWith(' ')) {
                          cursorPosition = formatted.length + 1;
                        } else {
                          cursorPosition = formatted.length;
                        }

                        _cardNumberController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: cursorPosition > formatted.length
                                ? formatted.length
                                : cursorPosition,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                            labelText: 'MM/YY',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            counterText: "", // Hide the counter
                          ),
                          keyboardType: TextInputType.datetime,
                          maxLength: 5,
                          onChanged: (value) {
                            // Remove any non-digit characters
                            String numbers =
                                value.replaceAll(RegExp(r'\D'), '');

                            // Format the string with / after 2 digits
                            String formatted = '';
                            for (int i = 0; i < numbers.length; i++) {
                              if (i == 2 && numbers.length > 2) {
                                formatted += '/';
                              }
                              formatted += numbers[i];
                            }

                            // Update the controller if the text is different
                            if (formatted != value) {
                              _expiryDateController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                    offset: formatted.length),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            prefixIcon: Icon(Icons.security),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            counterText: "", // Hide the counter
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [Color(0xFF1A237E), Color(0xFF0D47A1)]
                : [Colors.white, Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 28,
                        color: isSelected ? Colors.white : Color(0xFF1A237E),
                      ),
                      SizedBox(width: 16),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateCreditCard() {
    if (_cardNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all credit card details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        margin: EdgeInsets.only(top: 30, bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.payment_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(width: 20),
                            Flexible(
                              child: Text(
                                'Payment Method',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Choose how you want to pay',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 40),
                      _buildPaymentButton(
                        text: 'Pay on Delivery',
                        isSelected: isOnDelivery,
                        icon: Icons.local_shipping_rounded,
                        onTap: () {
                          setState(() {
                            isOnDelivery = !isOnDelivery;
                            isCreditCard = false;
                            paymentMethod = isOnDelivery ? 'on delivery' : '';
                          });
                        },
                      ),
                      _buildPaymentButton(
                        text: 'Credit Card',
                        isSelected: isCreditCard,
                        icon: Icons.credit_card_rounded,
                        onTap: () {
                          setState(() {
                            isCreditCard = !isCreditCard;
                            isOnDelivery = false;
                            paymentMethod = isCreditCard ? 'credit card' : '';
                          });
                        },
                      ),
                      _buildCreditCardFields(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    CustomNextButton(
                      onPressed: () async {
                        if (paymentMethod == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select a payment method',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (isCreditCard && !_validateCreditCard()) {
                          return;
                        }

                        await LocalStorageService()
                            .save('payment_method', paymentMethod);

                        LocalStorageService _service = LocalStorageService();
                        String orderJsonString = await _service.get('order');
                        String city = await _service.get('city');
                        String street = await _service.get('street');

                        dynamic orderDataParsed = jsonDecode(orderJsonString);
                        Map<String, dynamic> orderData;

                        if (orderDataParsed is List) {
                          orderData = orderDataParsed.isNotEmpty
                              ? Map<String, dynamic>.from(orderDataParsed[0])
                              : {};
                        } else {
                          orderData =
                              Map<String, dynamic>.from(orderDataParsed);
                        }

                        Map<String, dynamic> completeOrderData = {
                          ...orderData,
                          'city': jsonDecode(city),
                          'street': jsonDecode(street),
                          'payment_method': paymentMethod,
                          'user_id': await AuthService().getCurrentUserId()!,
                          'created_at': DateTime.now().toString(),
                        };

                        if (isCreditCard) {
                          completeOrderData['card_number'] =
                              _cardNumberController.text;
                          completeOrderData['expiry_date'] =
                              _expiryDateController.text;
                          completeOrderData['secret_code'] = _cvvController.text;
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmationScreen(
                              orderData: completeOrderData,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
