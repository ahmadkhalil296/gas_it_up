import 'package:flutter/material.dart';

import '../widgets/back_button.dart';
import '../widgets/next_button.dart';

class ShoppingCart extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;


  ShoppingCart({ required this.selectedItems});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.selectedItems.map((item) {
      return {...item, 'quantity': 1};
    }).toList();
  }

  void updateQuantity(int index, int change) {
    setState(() {
      cartItems[index]['quantity'] += change;
      if (cartItems[index]['quantity'] < 1) {
        cartItems[index]['quantity'] = 1;
      }
    });
  }

  double calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(cartItems[index]['image'], width: 50, height: 50),
                  title: Text(cartItems[index]['name'], style: Theme.of(context).textTheme.bodyMedium,),
                  subtitle: Text('\$${cartItems[index]['price']}',style: Theme.of(context).textTheme.bodyMedium,),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove,color: Colors.white,),
                        onPressed: () => updateQuantity(index, -1),
                      ),
                      Text('${cartItems[index]['quantity']}',style: Theme.of(context).textTheme.bodyMedium),
                      IconButton(
                        icon: Icon(Icons.add,color: Colors.white),
                        onPressed: () => updateQuantity(index, 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${calculateTotal().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomBackButton(),
                  CustomNextButton(onPressed: () async{
                    try{

                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid quantity or price'),));

                    }

                  })

                ]
            ),
          )
        ],
      ),
    );
  }
}
