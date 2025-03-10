import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportScreen extends StatefulWidget {
  final List<List<Map<String, dynamic>>> placedOrdersHistory;
  final String selectedPaymentMethod;

  ReportScreen(
      {required this.placedOrdersHistory, required this.selectedPaymentMethod});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late List<List<Map<String, dynamic>>> placedOrdersHistory;
  bool isLoading = true;
  int cashCount = 0;
  int creditCount = 0;
  List<Map<String, dynamic>> allOrders = [];

  @override
  void initState() {
    super.initState();
    placedOrdersHistory = widget.placedOrdersHistory;
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.56.1/app/get_orders.php'));
      if (response.statusCode == 200) {
        List<dynamic> orders = json.decode(response.body);
        setState(() {
          allOrders = orders
              .map((order) => {
                    'order_id': order['order_id'],
                    'order_name': order['order_name'],
                    'totalPrice':
                        double.tryParse(order['price'].toString()) ?? 0.0,
                    'payment_method': order['payment_method'],
                    'timestamp': order['timestamp'],
                  })
              .toList();
          placedOrdersHistory = [allOrders];
          countPaymentMethods(allOrders);
          isLoading = false;
        });
        saveReportToDatabase(
            calculateTotalSales([allOrders]), allOrders.length);
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void countPaymentMethods(List<Map<String, dynamic>> allOrders) {
    int cashOrders = 0;
    int creditOrders = 0;
    for (var order in allOrders) {
      if (order['payment_method'] == 'cash') {
        cashOrders++;
      } else if (order['payment_method'] == 'credit') {
        creditOrders++;
      }
    }
    setState(() {
      cashCount = cashOrders;
      creditCount = creditOrders;
    });
  }

  Future<void> saveReportToDatabase(double totalSales, int totalOrders) async {
    final url = Uri.parse('http://192.168.56.1/app/save_report.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
          json.encode({'total_sales': totalSales, 'total_orders': totalOrders}),
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['status'] == 'success') {
        print('Report saved with ID: ${result['report_id']}');
      } else {
        print('Failed to save report: ${result['message']}');
      }
    } else {
      print(
          'Failed to save report with HTTP status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalOrders = 0;
    double totalSales = 0;
    if (!isLoading && placedOrdersHistory.isNotEmpty) {
      totalOrders = calculateTotalOrders(placedOrdersHistory);
      totalSales = calculateTotalSales(placedOrdersHistory);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales and Inventory Report'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCard('Sales', [
                      buildRow(
                          'Total Sales:', '\$${totalSales.toStringAsFixed(2)}'),
                    ]),
                    SizedBox(height: 20),
                    buildCard('Inventory', [
                      buildRow('Total Orders:', '$totalOrders'),
                    ]),
                    SizedBox(height: 20),
                    buildCard('Orders', [
                      if (allOrders.isEmpty)
                        Text('No orders found', style: TextStyle(fontSize: 16)),
                      for (var order in allOrders) buildOrderDetail(order),
                    ]),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildCard(String title, List<Widget> content) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Divider(),
          ...content,
        ],
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget buildOrderDetail(Map<String, dynamic> order) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      title: Text(order['order_name'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ID: ${order['order_id']}'),
          Text('Total Price: \$${order['totalPrice'].toStringAsFixed(2)}'),
          Text('Payment Method: ${order['payment_method']}'),
          Text('Timestamp: ${order['timestamp']}'),
        ],
      ),
    );
  }

  double calculateTotalSales(
      List<List<Map<String, dynamic>>> placedOrdersHistory) {
    return placedOrdersHistory.fold(
      0,
      (total, current) =>
          total +
          current.fold(
              0, (orderTotal, order) => orderTotal + order['totalPrice']),
    );
  }

  int calculateTotalOrders(
      List<List<Map<String, dynamic>>> placedOrdersHistory) {
    return placedOrdersHistory.fold(
      0,
      (total, current) => total + current.length,
    );
  }
}
