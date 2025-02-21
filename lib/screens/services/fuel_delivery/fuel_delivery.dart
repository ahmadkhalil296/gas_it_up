import 'package:flutter/material.dart';
import 'package:mechanic_services/widgets/selectable_field.dart';

import '../../../widgets/back_button.dart';
import '../../../widgets/next_button.dart';
import '../../../widgets/selectable_radio_button.dart';
import 'fuel_price.dart';

class FuelDelivery extends StatefulWidget {
  const FuelDelivery({super.key});

  @override
  State<FuelDelivery> createState() => _FuelDeliveryState();
}

class _FuelDeliveryState extends State<FuelDelivery> {

  bool is95Selected = false;
  bool is98Selected = false;
  bool isDieselSelected = false;

  String selectedFuel = '';

  bool isOJMSelected = false;
  bool isApecSelected = false;
  bool isCoralSelected = false;
  bool isIPTSelected = false;
  bool isTotalSelected = false;
  bool isMedcoSelected = false;

  String selectedProvider = '';
  double price = 0;

  @override
  Widget build(BuildContext context) {

    void updateSelection(String selected) {
      setState(() {
        isOJMSelected = selected == 'OJM';
        isApecSelected = selected == 'Apec';
        isCoralSelected = selected == 'Coral';
        isIPTSelected = selected == 'IPT';
        isTotalSelected = selected == 'Total';
        isMedcoSelected = selected == 'Medco';
      });
     if(isOJMSelected) selectedProvider = 'OJM';
      if(isApecSelected) selectedProvider = 'Apec';
      if(isCoralSelected) selectedProvider = 'Coral';
      if(isIPTSelected) selectedProvider = 'IPT';
      if(isTotalSelected) selectedProvider = 'Total';
      if(isMedcoSelected) selectedProvider = 'Medco';
    }



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

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      is95Selected = !is95Selected;
                      is98Selected = false;
                      isDieselSelected = false;
                      selectedFuel = is95Selected ? 'Unleaded 95' : '';
                      price = is95Selected? 0.79 : 0;
                    });
                  },
                  child: SelectableField(
                      isSelected: is95Selected,
                      text1: 'Unleaded 95',
                      text2: '0.79\$/Liter'
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      is98Selected = !is98Selected;
                      is95Selected = false;
                      isDieselSelected = false;
                      selectedFuel = is98Selected ? 'Unleaded 98' : '';
                      price = is98Selected? 0.82 : 0;
                    });
                  },
                  child: SelectableField(
                      isSelected: is98Selected,
                      text1: 'Unleaded 98',
                      text2: '0.82\$/Liter'
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDieselSelected = !isDieselSelected;
                      is95Selected = false;
                      is98Selected = false;
                      selectedFuel = isDieselSelected ? 'Diesel' : '';
                      price = isDieselSelected? 0.75 : 0;
                    });
                  },
                  child: SelectableField(
                      isSelected: isDieselSelected,
                      text1: 'Diesel',
                      text2: '0.75\$/Liter'
                  ),
                ),
              ]
            ),
          ),




            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSelectableButton('OJM', isOJMSelected, () => updateSelection('OJM')),
                    const SizedBox(width: 20),
                    buildSelectableButton('Apec', isApecSelected, () => updateSelection('Apec')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSelectableButton('Coral', isCoralSelected, () => updateSelection('Coral')),
                    const SizedBox(width: 20),
                    buildSelectableButton('IPT', isIPTSelected, () => updateSelection('IPT')),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSelectableButton('Total', isTotalSelected, () => updateSelection('Total')),
                    const SizedBox(width: 20),
                    buildSelectableButton('Medco', isMedcoSelected, () => updateSelection('Medco')),
                  ],
                ),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomBackButton(),
                CustomNextButton(onPressed: (){
                  if(selectedProvider == '' || price == 0){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please select a provider and fuel type'),));
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FuelPrice(provider: selectedProvider,price: price,fuelType: selectedFuel)));
                  }
                })

              ]
            )




          ]
        ),
      )
    );
  }
}



Widget buildSelectableButton(String text, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: SelectableRadioButton(text: text, isSelected: isSelected),
  );
}


