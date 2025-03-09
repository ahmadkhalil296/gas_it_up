import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../services/AuthService.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/back_button.dart';
import '../../widgets/next_button.dart';
import '../../widgets/selectable_field.dart';
import '../order/get_address.dart';

class TireChange extends StatefulWidget {
  const TireChange({super.key});

  @override
  State<TireChange> createState() => _TireChangeState();
}

class _TireChangeState extends State<TireChange> {

  bool isTireInflation = false;
  bool isTireRepair = false;
  bool isTireChange = false;

  String selectedService = '';
  int price = 0;


  final List<Map<String, String>> tires = [
    {"size": "225/40/17", "price": "40\$"},
    {"size": "225/45/17", "price": "40\$"},
    {"size": "225/50/17", "price": "40\$"},
    {"size": "225/40/18", "price": "50\$"},
    {"size": "225/45/18", "price": "50\$"},
    {"size": "225/50/18", "price": "50\$"},
    {"size": "235/40/17", "price": "45\$"},
    {"size": "235/45/17", "price": "45\$"},
    {"size": "235/50/17", "price": "45\$"},
    {"size": "245/40/18", "price": "55\$"},
    {"size": "245/45/18", "price": "55\$"},
    {"size": "245/50/18", "price": "55\$"},
    {"size": "255/40/19", "price": "60\$"},
    {"size": "255/45/19", "price": "60\$"},
    {"size": "255/50/19", "price": "60\$"},
    {"size": "265/40/19", "price": "65\$"},
    {"size": "265/45/19", "price": "65\$"},
    {"size": "265/50/19", "price": "65\$"},
    {"size": "275/40/20", "price": "70\$"},
    {"size": "275/45/20", "price": "70\$"},
    {"size": "275/50/20", "price": "70\$"},
    {"size": "285/40/20", "price": "75\$"},
    {"size": "285/45/20", "price": "75\$"},
    {"size": "285/50/20", "price": "75\$"},
  ];

  int? selectedIndex;


  @override
  Widget build(BuildContext context) {
    List<List<Map<String, String>>> rows = [];
    for (int i = 0; i < tires.length; i += 8) {
      rows.add(tires.sublist(i, i + 8 > tires.length ? tires.length : i + 8));
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage('assets/images/tire.png')),
                  SizedBox(width: 20),
                  Text('Tire Change',style: Theme.of(context).textTheme.headlineLarge)
                ]
            ),

            Column(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isTireInflation = !isTireInflation;
                      isTireRepair = false;
                      isTireChange = false;
                      selectedService = isTireInflation ? 'Tire Inflation' : '';
                      price = 2;
                    });
      },
                  child: SelectableField(
                      isSelected: isTireInflation,
                      text1: 'Tire Inflation',
                      text2: '2\$'
                  ),
                ),
                SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      isTireRepair = !isTireRepair;
                      isTireInflation = false;
                      isTireChange = false;
                      selectedService = isTireRepair ? 'Tire Repair' : '';
                      price = 3;
                    });
                  },
                  child: SelectableField(
                      isSelected: isTireRepair,
                      text1: 'Tire Repair',
                      text2: '3\$'
                  ),
                ),
                SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      isTireChange = !isTireChange;
                      isTireInflation = false;
                      isTireRepair = false;
                      selectedService = isTireChange ? 'Tire Change' : '';
                      price = 3;
                    });
                  },
                  child: SelectableField(
                      isSelected: isTireChange,
                      text1: 'Tire Change',

                  ),
                ),
              ],
            ),


            Center(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(8, 174, 234, 0.54),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: rows.map((row) {
                      return Row(
                        children: row.asMap().entries.map((entry) {
                          int index = tires.indexOf(entry.value); // Get index globally
                          bool isSelected = selectedIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = (selectedIndex == index) ? null : index;

                              });
                            },
                            child: Container(
                              width: 130,
                              height: 90,
                              margin: index % 8 == 0 ? EdgeInsets.only(right: 10) : EdgeInsets.all(10),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    entry.value["size"]!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    entry.value["price"]!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
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
                        if(selectedService == ''){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please select a service'),));
                        }else{
                          if(selectedService == 'Tire Change' && selectedIndex == null){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please select a tire type'),));
                            return;
                          }
                          String key = selectedService == 'Tire Change' ? 'tire' : 'price';
                          String value = selectedService == 'Tire Change' ? jsonEncode(tires.elementAt(selectedIndex!)) : price.toString();

                          Map<String,dynamic> order = {
                            'Service' : 'Tire Change',
                            'type' :selectedService,
                            key:value,

                            'user_id': await AuthService.getCurrentUserId()!,
                            'created_at' : DateTime.now().toString()

                          };
                          await LocalStorageService().save('order',jsonEncode(order));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetAddress()));



                        }
                      }catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid quantity or price'),));

                      }

                    })

                  ]
              ),
            )

          ],
        )
      ),
    );
  }
}
