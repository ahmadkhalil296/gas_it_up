import 'package:flutter/material.dart';

import '../shopping_cart.dart';
import '../../widgets/back_button.dart';

class CarAccesories extends StatefulWidget {
  const CarAccesories({super.key});

  @override
  State<CarAccesories> createState() => _CarAccesoriesState();
}

class _CarAccesoriesState extends State<CarAccesories> {
  final List<Map<String, dynamic>> accessories = [
    {
      'name': 'Steering',
      'price': 15,
      'image': 'assets/images/car_accessories/1.png'
    },
    {
      'name': 'Oil (5L)',
      'price': 10,
      'image': 'assets/images/car_accessories/2.png'
    },
    {
      'name': 'Spark Plug',
      'price': 3,
      'image': 'assets/images/car_accessories/3.png'
    },
    {
      'name': 'Battery',
      'price': 80,
      'image': 'assets/images/car_accessories/5.png'
    },
    {
      'name': 'Ball Bearing',
      'price': 30,
      'image': 'assets/images/car_accessories/6.png'
    },
    {
      'name': 'Brake pads',
      'price': 25,
      'image': 'assets/images/car_accessories/7.png'
    },
    {
      'name': 'Disk Brake',
      'price': 35,
      'image': 'assets/images/car_accessories/7.png'
    },
    {
      'name': 'Cooling Fan',
      'price': 35,
      'image': 'assets/images/car_accessories/8 1.png'
    },
    {
      'name': 'Piston',
      'price': 25,
      'image': 'assets/images/car_accessories/9.png'
    },
    {
      'name': 'Fuel Filter',
      'price': 10,
      'image': 'assets/images/car_accessories/10.png'
    },
    {
      'name': 'Air Filter',
      'price': 15,
      'image': 'assets/images/car_accessories/11.png'
    },
    {
      'name': 'Oil Filter',
      'price': 7,
      'image': 'assets/images/car_accessories/4.png'
    },
    {
      'name': 'Timing Belt',
      'price': 10,
      'image': 'assets/images/car_accessories/12.png'
    },
    {
      'name': 'Wiper Blades',
      'price': 15,
      'image': 'assets/images/car_accessories/13.png'
    },
    {
      'name': 'Headlight',
      'price': 35,
      'image': 'assets/images/car_accessories/14.png'
    },
    {
      'name': 'Water Pump',
      'price': 25,
      'image': 'assets/images/car_accessories/15.png'
    },
    {
      'name': 'Fuel Pump',
      'price': 35,
      'image': 'assets/images/car_accessories/16.png'
    },
    {
      'name': 'Clutch',
      'price': 75,
      'image': 'assets/images/car_accessories/18.png'
    },
  ];

  final Set<int> selectedItems = {};
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int itemsPerPage = 9;

  @override
  Widget build(BuildContext context) {
    int totalPages = (accessories.length / itemsPerPage).ceil();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(image: AssetImage('assets/images/car-parts.png')),
                  SizedBox(width: 20),
                  Text('Car Accessories',
                      style: Theme.of(context).textTheme.headlineLarge)
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Center(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: totalPages,
                  itemBuilder: (context, pageIndex) {
                    int startIndex = pageIndex * itemsPerPage;
                    int endIndex = (startIndex + itemsPerPage)
                        .clamp(0, accessories.length);
                    List<Map<String, dynamic>> pageItems =
                        accessories.sublist(startIndex, endIndex);
                    return GridView.builder(
                      padding: EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: pageItems.length,
                      itemBuilder: (context, index) {
                        int globalIndex = startIndex + index;
                        bool isSelected = selectedItems.contains(globalIndex);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedItems.remove(globalIndex);
                              } else {
                                selectedItems.add(globalIndex);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.blueAccent : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(pageItems[index]['image'],
                                    height: 80),
                                SizedBox(height: 8),
                                Text(pageItems[index]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black)),
                                Text('${pageItems[index]['price']} \$',
                                    style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(index);
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          _currentPage == index ? Colors.orange : Colors.blue,
                      child: Text('${index + 1}',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomBackButton(),
                ElevatedButton.icon(
                  onPressed: () {
                    List<Map<String, dynamic>> selectedAccessories =
                        selectedItems
                            .map((index) => accessories[index])
                            .toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShoppingCart(selectedItems: selectedAccessories)),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 20,
                  ),
                  label: Text(
                    'Cart (${selectedItems.length})',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
