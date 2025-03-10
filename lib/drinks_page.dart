import 'package:flutter/material.dart';
import 'orders.dart';

class DrinksPage extends StatelessWidget {
  final List<Map<String, dynamic>> drinkItems = [
    {
      'name': 'Iced Coffee',
      'description': 'Chilled coffee with milk and ice cubes',
      'price': 3.49,
      'quantity': 0,
    },
    {
      'name': 'Green Tea',
      'description': 'Refreshing Japanese green tea',
      'price': 2.99,
      'quantity': 0,
    },
    {
      'name': 'Fresh Orange Juice',
      'description': 'Squeezed oranges for a vitamin C boost',
      'price': 4.29,
      'quantity': 0,
    },
    {
      'name': 'Mango Smoothie',
      'description': 'Blended mango, yogurt, and honey',
      'price': 4.99,
      'quantity': 0,
    },
    {
      'name': 'Lemonade',
      'description': 'Tangy and sweet lemon-flavored drink',
      'price': 2.49,
      'quantity': 0,
    },
    {
      'name': 'Iced Matcha Latte',
      'description': 'Matcha green tea with milk and ice',
      'price': 3.99,
      'quantity': 0,
    },
    {
      'name': 'Coconut Water',
      'description': 'Refreshing coconut water straight from the coconut',
      'price': 3.79,
      'quantity': 0,
    },
    {
      'name': 'Strawberry Smoothie',
      'description': 'Smoothie made with fresh strawberries and yogurt',
      'price': 4.49,
      'quantity': 0,
    },
    {
      'name': 'Chocolate Milkshake',
      'description': 'Rich and creamy chocolate milkshake',
      'price': 5.99,
      'quantity': 0,
    },
    {
      'name': 'Cappuccino',
      'description': 'Espresso topped with frothed milk and chocolate powder',
      'price': 3.79,
      'quantity': 0,
    },
    {
      'name': 'Hot Chocolate',
      'description': 'Warm cocoa with whipped cream and marshmallows',
      'price': 3.99,
      'quantity': 0,
    },
    {
      'name': 'Iced Tea',
      'description': 'Cold black tea with lemon and sugar',
      'price': 2.79,
      'quantity': 0,
    },
    {
      'name': 'Soda',
      'description': 'Carbonated soft drink in various flavors',
      'price': 1.99,
      'quantity': 0,
    },
    {
      'name': 'Mineral Water',
      'description': 'Still or sparkling mineral water',
      'price': 1.49,
      'quantity': 0,
    },
    {
      'name': 'Coffee Latte',
      'description': 'Espresso with steamed milk and a touch of foam',
      'price': 4.49,
      'quantity': 0,
    },
    {
      'name': 'Milk',
      'description': 'Fresh cow\'s milk',
      'price': 2.29,
      'quantity': 0,
    },
    {
      'name': 'Pineapple Juice',
      'description': 'Freshly squeezed pineapple juice',
      'price': 3.99,
      'quantity': 0,
    },
    {
      'name': 'Chai Tea',
      'description': 'Spiced Indian tea with milk and sugar',
      'price': 3.49,
      'quantity': 0,
    },
  ];

  void addToOrderList(BuildContext context, Map<String, dynamic> drinkItem) {
    drinkItem['quantity'] = (drinkItem['quantity'] ?? 0) + 1;
    addToOrder(drinkItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item added to order!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drinks'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drink.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.builder(
            itemCount: drinkItems.length,
            itemBuilder: (context, index) {
              final drinkItem = drinkItems[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      drinkItem['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      drinkItem['description'],
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${drinkItem['price'].toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        PlusButton(
                          onTap: () {
                            addToOrderList(context, drinkItem);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  final VoidCallback onTap;

  const PlusButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(8),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DrinksPage(),
  ));
}
