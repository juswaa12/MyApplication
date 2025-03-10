import 'package:flutter/material.dart';
import 'orders.dart';

class FoodPage extends StatelessWidget {
  final List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Pizza Margherita',
      'description': 'Classic pizza with tomato sauce, mozzarella, and basil',
      'price': 12.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Chicken Biryani',
      'description': 'Spiced rice dish with tender chicken and aromatic spices',
      'price': 9.49,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Chocolate Brownie',
      'description': 'Rich and fudgy brownie topped with vanilla ice cream',
      'price': 5.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Caesar Salad',
      'description':
          'Fresh romaine lettuce with Caesar dressing, croutons, and Parmesan cheese',
      'price': 8.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Lasagna',
      'description':
          'Layers of pasta with ground meat, tomato sauce, and melted cheese',
      'price': 10.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Grilled Salmon',
      'description': 'Salmon fillet seasoned and grilled to perfection',
      'price': 15.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Chicken Caesar Wrap',
      'description':
          'Grilled chicken, romaine lettuce, and Caesar dressing wrapped in a tortilla',
      'price': 7.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Margarita Cocktail',
      'description':
          'Classic cocktail made with tequila, lime juice, and triple sec',
      'price': 6.49,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Vegetable Stir-Fry',
      'description': 'Assorted vegetables stir-fried with soy sauce and garlic',
      'price': 8.49,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Blueberry Pancakes',
      'description':
          'Fluffy pancakes filled with fresh blueberries and served with maple syrup',
      'price': 7.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Mushroom Risotto',
      'description':
          'Creamy risotto cooked with mushrooms, white wine, and Parmesan cheese',
      'price': 11.49,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Garlic Bread',
      'description': 'Toasted bread topped with garlic butter and herbs',
      'price': 4.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Chicken Quesadilla',
      'description': 'Grilled tortilla filled with chicken, cheese, and salsa',
      'price': 6.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Lemon Tart',
      'description': 'Tangy lemon custard in a buttery pastry crust',
      'price': 4.49,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Beef Stir-Fry',
      'description':
          'Tender beef strips stir-fried with vegetables in a savory sauce',
      'price': 9.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Caprese Salad',
      'description':
          'Fresh tomatoes, mozzarella cheese, and basil drizzled with balsamic glaze',
      'price': 7.49,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Pulled Pork Sandwich',
      'description': 'Slow-cooked pulled pork piled high on a toasted bun',
      'price': 8.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Tiramisu',
      'description':
          'Classic Italian dessert made with layers of coffee-soaked ladyfingers and mascarpone cheese',
      'price': 6.99,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Spinach and Feta Quiche',
      'description': 'Flaky pastry filled with spinach, feta cheese, and eggs',
      'price': 5.49,
      'color': Colors.green,
      'quantity': 0,
    },
    {
      'name': 'Chicken Noodle Soup',
      'description': 'Hearty soup made with chicken, vegetables, and noodles',
      'price': 6.99,
      'color': Colors.green,
      'quantity': 0,
    },
  ];

  void addToOrderList(BuildContext context, Map<String, dynamic> foodItem) {
    foodItem['quantity'] = (foodItem['quantity'] ?? 0) + 1;
    addToOrder(foodItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item added to order!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foods'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/foodings.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            final foodItem = foodItems[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    foodItem['name'],
                    style: TextStyle(color: foodItem['color']),
                  ),
                  subtitle: Text(
                    foodItem['description'],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${foodItem['price'].toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      PlusButton(
                        onTap: () {
                          addToOrderList(context, foodItem);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
