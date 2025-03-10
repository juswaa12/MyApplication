import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlacedOrdersPage extends StatefulWidget {
  final List<List<Map<String, dynamic>>> placedOrdersHistory;
  final String selectedPaymentMethod;

  PlacedOrdersPage({
    required this.placedOrdersHistory,
    required this.selectedPaymentMethod,
  });

  @override
  _PlacedOrdersPageState createState() => _PlacedOrdersPageState();
}

class _PlacedOrdersPageState extends State<PlacedOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Placed Orders'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/placed.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.placedOrdersHistory.isEmpty)
                  Center(
                    child: Text(
                      'No orders placed yet.',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                for (int i = 0; i < widget.placedOrdersHistory.length; i++)
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Placed Order ${i + 1}:',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var order in widget.placedOrdersHistory[i])
                              Container(
                                margin: EdgeInsets.only(bottom: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${order['name']}',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text('Quantity: ${order['quantity']}'),
                                    Text(
                                        'Total Price: \$${order['totalPrice']}'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white.withOpacity(0.8),
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${calculateTotalCost(widget.placedOrdersHistory[i]).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Payment Method:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.selectedPaymentMethod,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveToDatabase,
        tooltip: 'Save to Database',
        child: Icon(Icons.save),
      ),
    );
  }

  double calculateTotalCost(List<Map<String, dynamic>> orderList) {
    return orderList.fold(
      0,
      (total, current) =>
          total + double.parse(current['totalPrice'].toString()),
    );
  }

  Future<void> _saveToDatabase() async {
    final ordersData = widget.placedOrdersHistory.map((orderList) {
      final items = orderList
          .map(
              (order) => {'name': order['name'], 'quantity': order['quantity']})
          .toList();
      final totalPrice = calculateTotalCost(orderList).toString();
      return {
        'items': items,
        'totalPrice': totalPrice,
        'paymentMethod': widget.selectedPaymentMethod,
      };
    }).toList();

    final url = Uri.parse('http://192.168.56.1/app/save_order.php');

    try {
      for (int i = 0; i < ordersData.length; i++) {
        final orderData = ordersData[i];

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(orderData),
        );

        if (response.statusCode == 200) {
          print('Order ${i + 1} saved successfully!');
        } else {
          print('Error saving order ${i + 1}: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error connecting to server: $e');
    }
  }
}
