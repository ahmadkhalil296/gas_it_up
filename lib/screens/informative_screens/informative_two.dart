import 'package:flutter/material.dart';

class InformativeTwo extends StatelessWidget {
  const InformativeTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/location.png')),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
              child: Text('Get Gas for your car from Anywhere in the city',style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center)),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Effortless car care at the touch of a button. From fuel delivery to complete maintenance, we\'re here to keep you moving smoothly and efficiently',style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
