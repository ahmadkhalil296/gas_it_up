import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/bullet_list.dart';

import '../../services/AuthService.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/selectable_field.dart';
import '../order/get_address.dart';

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
  int price = 0;

  var exteriorWashDescription = [
    'Washing and scrubbing the body, windows and mirrors',
    'cleaning tires, rims, and wheel wells'
  ];
  var interiorWashDescription = [
    'Vacuuming carpets, seats, and trunk. Wiping down dashboards, consoles, and door panels.  ',
    'Cleaning and conditioning leather or fabric seats.',
    'Removing stains and odors.'
  ];
  var fullWashDescription = [
    'All services in the outer wash and inner wash categories. ',
    'Additional detailing like waxing, tire polishing, and interior deodorizing.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 0),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image(
                              image: AssetImage('assets/images/car_wash.png'),
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(width: 20),
                      Text('Car wash',
                          style: Theme.of(context).textTheme.headlineLarge)
                    ]),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExteriorSelected = !isExteriorSelected;
                                    isInteriorSelected = false;
                                    isFullSelected = false;
                                    selectedService = isExteriorSelected
                                        ? 'Exterior Wash'
                                        : '';
                                    price = 4;
                                  });
                                },
                                child: SelectableField(
                                    isSelected: isExteriorSelected,
                                    text1: 'Exterior Wash',
                                    text2: '4\$'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                  visible: isExteriorSelected,
                                  child: BulletList(exteriorWashDescription))
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isInteriorSelected = !isInteriorSelected;
                                    isExteriorSelected = false;
                                    isFullSelected = false;
                                    selectedService = isInteriorSelected
                                        ? 'Interior Wash'
                                        : '';
                                    price = 3;
                                  });
                                },
                                child: SelectableField(
                                    isSelected: isInteriorSelected,
                                    text1: 'Interior Wash',
                                    text2: '3\$'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                  visible: isInteriorSelected,
                                  child: BulletList(interiorWashDescription))
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFullSelected = !isFullSelected;
                                    isExteriorSelected = false;
                                    isInteriorSelected = false;
                                    selectedService =
                                        isFullSelected ? 'Full Wash' : '';
                                    price = 6;
                                  });
                                },
                                child: SelectableField(
                                    isSelected: isFullSelected,
                                    text1: 'Full Wash',
                                    text2: '6\$'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                  visible: isFullSelected,
                                  child: BulletList(fullWashDescription))
                            ],
                          ),
                        ]),
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'please select a service',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  backgroundColor:
                                      Color.fromRGBO(16, 56, 127, 1.0),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ));
                              } else {
                                Map<String, dynamic> order = {
                                  'Service': 'Car Wash',
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('invalid quantity or price'),
                              ));
                            }
                          })
                        ]),
                  )
                ])));
  }
}
