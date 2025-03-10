import 'package:flutter/material.dart';
import 'placed_orders.dart';

class TransactionPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderList;

  TransactionPage({required this.orderList});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String? selectedPaymentMethod;
  List<List<Map<String, dynamic>>> placedOrdersHistory = [];

  double calculateTotalCost() {
    return widget.orderList.fold(
      0,
      (total, current) => total + double.parse(current['totalPrice']),
    );
  }

  void placeOrder() {
    if (selectedPaymentMethod != null) {
      processTransaction(widget.orderList, selectedPaymentMethod!);

      placedOrdersHistory.add(List.from(widget.orderList));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlacedOrdersPage(
            placedOrdersHistory: placedOrdersHistory,
            selectedPaymentMethod: selectedPaymentMethod!,
          ),
        ),
      );

      setState(() {
        widget.orderList.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a payment method'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/trans.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.orderList.length,
                itemBuilder: (context, index) {
                  final order = widget.orderList[index];
                  return ListTile(
                    title: Text(
                      order['name'],
                      style: TextStyle(color: Colors.white), // changed here
                    ),
                    subtitle: Text(
                      'Quantity: ${order['quantity']}',
                      style: TextStyle(color: Colors.white), // changed here
                    ),
                    trailing: Text(
                      '\$${order['totalPrice']}',
                      style: TextStyle(color: Colors.white), // changed here
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${calculateTotalCost().toStringAsFixed(2)}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Select Payment Method'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedPaymentMethod = 'Cash';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cash'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedPaymentMethod = 'Credit';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('Credit'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child:
                        Text(selectedPaymentMethod ?? 'Select Payment Method'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: placeOrder,
                    child: Text('Place Order'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void processTransaction(
    List<Map<String, dynamic>> orderList, String paymentMethod) {
  for (var order in orderList) {
    addToOrder(order);
    print(
        "Processing order for: ${order['name']} with quantity: ${order['quantity']}");
  }
}

void addToOrder(Map<String, dynamic> order) {}

List<Map<String, dynamic>> transactionList = [];

void addToTransaction(Map<String, dynamic> item) {
  int index =
      transactionList.indexWhere((element) => element['name'] == item['name']);

  if (index != -1) {
    transactionList[index]['quantity'] = transactionList[index]['quantity'] + 1;
    transactionList[index]['totalPrice'] =
        transactionList[index]['price'] * transactionList[index]['quantity'];
  } else {
    transactionList.add({
      'name': item['name'],
      'description': item['description'],
      'price': item['price'],
      'quantity': 1,
      'totalPrice': item['price'],
    });
  }
}
