import 'package:flutter/material.dart';
import 'transaction.dart'; 

List<Map<String, dynamic>> orderList = [];

void addToOrder(Map<String, dynamic> item) {
  bool itemExists = false;
  for (var order in orderList) {
    if (order['name'] == item['name']) {
      order['quantity'] = (order['quantity'] ?? 0) + 1;
      order['totalPrice'] =
          (order['price'] * (order['quantity'] ?? 1)).toStringAsFixed(2);
      order['isOrdered'] = true; 
      itemExists = true;
      break;
    }
  }
  if (!itemExists) {
    orderList.add({
      'name': item['name'],
      'price': item['price'],
      'quantity': 1,
      'totalPrice': item['price'].toStringAsFixed(2),
      'isOrdered': true,
    });
  }
}

void removeFromOrder(Map<String, dynamic> item) {
  for (var order in orderList) {
    if (order['name'] == item['name']) {
      if (order['quantity'] > 1) {
        order['quantity'] = order['quantity'] - 1;
        order['totalPrice'] =
            (order['price'] * (order['quantity'] ?? 1)).toStringAsFixed(2);
      } else {
        orderList.remove(order);
      }
      break;
    }
  }
}

double calculateTotalCost() {
  return orderList.fold(
    0,
    (total, current) => total + double.parse(current['totalPrice']),
  );
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> displayedOrders = [];

  @override
  void initState() {
    super.initState();
    displayedOrders = List.from(orderList);
  }

  bool get hasItemsInOrder => orderList.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (orderList.isEmpty) {
      displayedOrders.clear();
    } else {
      displayedOrders = List.from(orderList);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders List'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/orderlist.jpg',
            fit: BoxFit.cover,
          ),
          ListView.builder(
            itemCount: displayedOrders.length,
            itemBuilder: (context, index) {
              final order = displayedOrders[index];
              return Card(
                color: order['isOrdered'] ? Colors.green : Colors.white,
                child: ListTile(
                  title: Text(
                    order['name'],
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Quantity: ${order['quantity']}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${order['totalPrice']}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          removeFromOrder(order);
                          setState(() {
                            displayedOrders.remove(order);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item removed from order'),
                            ),
                          );
                        },
                        child: Text('-'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (hasItemsInOrder)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total: \$${calculateTotalCost().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TransactionPage(orderList: orderList),
                          ),
                        );
                      },
                      child: Text('Payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!hasItemsInOrder)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No items in order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrdersPage(),
  ));
}
