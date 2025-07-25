import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/selectable_field.dart';

import '../../services/AuthService.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../order/get_address.dart';

class OtherServices extends StatefulWidget {
  const OtherServices({super.key});

  @override
  State<OtherServices> createState() => _OtherServicesState();
}

class _OtherServicesState extends State<OtherServices> {
  bool isBatteryDie = false;
  bool isCarScanner = false;
  bool isOilChange = false;
  bool isCoolantLevel = false;

  String selectedService = '';

  int price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage(
                          'assets/images/other_services_icon_white.png'),
                      height: 40,
                    ),
                    SizedBox(width: 20),
                    Text('Other Services',
                        style: Theme.of(context).textTheme.headlineLarge)
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage('assets/images/other_services.png'),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isBatteryDie = !isBatteryDie;
                        isCarScanner = false;
                        isOilChange = false;
                        isCoolantLevel = false;
                        selectedService = isBatteryDie ? 'Battery Die' : '';
                        price = 3;
                      });
                    },
                    child: SelectableField(
                      text1: 'Battery Die',
                      text2: '3\$',
                      isSelected: isBatteryDie,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isBatteryDie = false;
                        isCarScanner = !isCarScanner;
                        isOilChange = false;
                        isCoolantLevel = false;
                        selectedService = isCarScanner ? 'Car Scanner' : '';
                        price = 3;
                      });
                    },
                    child: SelectableField(
                      text1: 'Car Scanner',
                      text2: '3\$',
                      isSelected: isCarScanner,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isBatteryDie = false;
                        isCarScanner = false;
                        isOilChange = !isOilChange;
                        isCoolantLevel = false;
                        selectedService = isOilChange ? 'Oil Change' : '';
                        price = 3;
                      });
                    },
                    child: SelectableField(
                      text1: 'Oil Change',
                      text2: '3\$',
                      isSelected: isOilChange,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isBatteryDie = false;
                        isCarScanner = false;
                        isOilChange = false;
                        isCoolantLevel = !isCoolantLevel;
                        selectedService = isCoolantLevel ? 'Coolant Level' : '';
                        price = 5;
                      });
                    },
                    child: SelectableField(
                      text1: 'Coolant Level',
                      text2: '5\$',
                      isSelected: isCoolantLevel,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomBackButton(),
                      CustomNextButton(onPressed: () async {
                        try {
                          if (selectedService == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'please select a service',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              backgroundColor: Color.fromRGBO(16, 56, 127, 1.0),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ));
                          } else {
                            Map<String, dynamic> order = {
                              'Service': 'Other Services',
                              'type': selectedService,
                              'price': price,
                              'user_id':
                                  await AuthService().getCurrentUserId()!,
                              'created_at': DateTime.now().toString()
                            };
                            await LocalStorageService()
                                .save('order', jsonEncode(order));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GetAddress()));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'could not submit the order at the moment'),
                          ));
                        }
                      })
                    ]),
              )
            ],
          )),
    );
  }
}
