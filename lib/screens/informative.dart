import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mechanic_services/GradientBackground.dart';
import 'package:mechanic_services/screens/informative_screens/informative_one.dart';
import 'package:mechanic_services/screens/informative_screens/informative_two.dart';

import 'informative_screens/informative_three.dart';

class Informative extends StatefulWidget {
  @override
  _InformativeState createState() => _InformativeState();
}

class _InformativeState extends State<Informative> {
  int _currentIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Automatically switch tabs every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 3;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // PageView for switching screens
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: _pageController,
              children: [
                InformativeOne(),
                InformativeTwo(),
                InformativeThree(),
              ],
            ),
          ),

          // Custom Rounded Rectangle Tabs
          Positioned(
            bottom: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () => _onTabTapped(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: _currentIndex == index ? 40 : 20,
                    height: 10,
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index ? Colors.white : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
