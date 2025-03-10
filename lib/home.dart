import 'package:flutter/material.dart';
import 'LogPage.dart';
import 'food_page.dart';
import 'drinks_page.dart';
import 'dessert_page.dart';
import 'orders.dart';
import 'DevelopersPage.dart'; // Import DevelopersPage.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TutorialHome(),
        '/orders': (context) => OrdersPage(),
        '/developers': (context) =>
            DevelopersPage(), // Define route for DevelopersPage.dart
      },
    );
  }
}

class TutorialHome extends StatefulWidget {
  const TutorialHome({Key? key}) : super(key: key);

  @override
  _TutorialHomeState createState() => _TutorialHomeState();
}

class _TutorialHomeState extends State<TutorialHome> {
  List<String> consolidatedOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KZVNT'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/dining.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                          image: AssetImage('assets/menu.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: null,
                    ),
                    buildListTileWithHover(
                      title: 'Foods',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FoodPage()),
                        );
                      },
                    ),
                    buildListTileWithHover(
                      title: 'Drinks',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DrinksPage()),
                        );
                      },
                    ),
                    buildListTileWithHover(
                      title: 'Dessert',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DessertPage()),
                        );
                      },
                    ),
                    buildListTileWithHover(
                      title: 'Placed Orders',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              buildListTileWithHover(
                title: 'Meet The Developers',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DevelopersPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: const Center(child: Image(image: AssetImage('assets/kzvnt.jpg'))),
    );
  }

  Widget buildListTileWithHover({
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.brown.withOpacity(0.1),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
