import 'package:flutter/material.dart';

class InformativeOne extends StatelessWidget {
  const InformativeOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            child: Image(image: AssetImage('assets/images/gas_it_up.png')),
          ),
          Text('Fuel At Your Fingertips',style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
