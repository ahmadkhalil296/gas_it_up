import 'package:flutter/material.dart';

class InformativeThree extends StatelessWidget {
  const InformativeThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Image(image: AssetImage('assets/images/gas_it_up.png'))),
          Container(
            margin: EdgeInsets.only(bottom: 15, left: 30, right: 30),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                "Starting here",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 15, left: 30, right: 30),
              child: Text(
                'Wherever you are, whatever the issue, we are always ready to keep you moving',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              child: Text(
                "About us",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
