import 'package:flutter/material.dart';
import 'orders.dart';

class DessertPage extends StatelessWidget {
  final List<Map<String, dynamic>> dessertItems = [
    {
      'name': 'Chocolate Cake',
      'description': 'Decadent chocolate cake with ganache frosting',
      'price': 6.99,
      'quantity': 0,
    },
    {
      'name': 'Tiramisu',
      'description':
          'Classic Italian dessert with layers of coffee-soaked ladyfingers',
      'price': 5.49,
      'quantity': 0,
    },
    {
      'name': 'Fruit Salad',
      'description': 'Assorted fresh fruits with a hint of mint',
      'price': 3.99,
      'quantity': 0,
    },
    {
      'name': 'Cheesecake',
      'description':
          'Creamy New York-style cheesecake with a graham cracker crust',
      'price': 7.49,
      'quantity': 0,
    },
    {
      'name': 'Macarons',
      'description': 'Colorful French almond cookies with various fillings',
      'price': 2.99,
      'quantity': 0,
    },
    {
      'name': 'Panna Cotta',
      'description': 'Silky Italian custard topped with berry compote',
      'price': 4.79,
      'quantity': 0,
    },
    {
      'name': 'Cupcake',
      'description': 'Fluffy vanilla cupcake with colorful frosting',
      'price': 2.49,
      'quantity': 0,
    },
    {
      'name': 'Brownie',
      'description': 'Fudgy chocolate brownie with walnuts',
      'price': 3.99,
      'quantity': 0,
    },
    {
      'name': 'Strawberry Shortcake',
      'description':
          'Light sponge cake layered with fresh strawberries and cream',
      'price': 6.29,
      'quantity': 0,
    },
    {
      'name': 'Fruit Tart',
      'description': 'Buttery pastry crust filled with fresh fruits',
      'price': 5.49,
      'quantity': 0,
    },
    {
      'name': 'Ice Cream Sundae',
      'description':
          'Scoops of ice cream topped with whipped cream and sprinkles',
      'price': 4.99,
      'quantity': 0,
    },
    {
      'name': 'Pavlova',
      'description': 'Crisp meringue base topped with whipped cream and fruits',
      'price': 5.99,
      'quantity': 0,
    },
    {
      'name': 'Lava Cake',
      'description': 'Warm chocolate cake with a molten chocolate center',
      'price': 6.49,
      'quantity': 0,
    },
    {
      'name': 'Banoffee Pie',
      'description': 'Pie with toffee, bananas, and whipped cream',
      'price': 7.99,
      'quantity': 0,
    },
    {
      'name': 'Key Lime Pie',
      'description': 'Pie with tart key lime filling and whipped cream',
      'price': 6.79,
      'quantity': 0,
    },
    {
      'name': 'Creme Brulee',
      'description': 'Creamy custard with caramelized sugar on top',
      'price': 8.49,
      'quantity': 0,
    },
    {
      'name': 'Apple Crisp',
      'description': 'Baked apple dessert with a crispy topping',
      'price': 5.99,
      'quantity': 0,
    },
    {
      'name': 'Chocolate Chip Cookies',
      'description': 'Classic cookies with chocolate chips',
      'price': 3.49,
      'quantity': 0,
    },
    {
      'name': 'Red Velvet Cake',
      'description':
          'Moist cake with a hint of cocoa and cream cheese frosting',
      'price': 6.99,
      'quantity': 0,
    },
    {
      'name': 'Baklava',
      'description': 'Layers of phyllo dough with nuts and honey syrup',
      'price': 7.29,
      'quantity': 0,
    },
    {
      'name': 'Eclairs',
      'description': 'Cream-filled pastries with chocolate icing',
      'price': 4.99,
      'quantity': 0,
    },
    {
      'name': 'Lemon Meringue Pie',
      'description': 'Pie with tangy lemon filling and fluffy meringue',
      'price': 7.49,
      'quantity': 0,
    },
  ];

  void addToOrderList(BuildContext context, Map<String, dynamic> dessertItem) {
    dessertItem['quantity'] = (dessertItem['quantity'] ?? 0) + 1;
    addToOrder(dessertItem);
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
        title: Text('Dessert'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/dessert.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          ListView.builder(
            itemCount: dessertItems.length,
            itemBuilder: (context, index) {
              final dessertItem = dessertItems[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      dessertItem['name'],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      dessertItem['description'],
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${dessertItem['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8),
                        PlusButton(
                          onTap: () {
                            addToOrderList(context, dessertItem);
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
    home: DessertPage(),
  ));
}
