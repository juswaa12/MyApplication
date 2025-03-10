import 'package:flutter/material.dart';
import 'report.dart';
import 'logpage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  bool isValidCredentials(BuildContext context, String email, String password) {
    Map<String, String> userCredentials = {
      'admin': 'admin123',
    };

    if (userCredentials.containsKey(email) &&
        userCredentials[email] == password) {
      saveLog(email);
      return true;
    } else {
      return false;
    }
  }

  // Save login log to the server
  Future<void> saveLog(String username) async {
    final url = Uri.parse('http://192.168.56.1/app/save_login_log.php');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'username': username,
        },
      );

      if (response.statusCode == 200) {
        print('Log saved successfully: ${response.body}');
      } else {
        print('Failed to save log: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving log: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    List<List<Map<String, dynamic>>> placedOrdersHistory = [
      [
        {
          'name': 'Item 1',
          'quantity': 2,
          'totalPrice': 10.0,
        },
        {
          'name': 'Item 2',
          'quantity': 3,
          'totalPrice': 15.0,
        },
      ],
      [
        {
          'name': 'Item 3',
          'quantity': 1,
          'totalPrice': 5.0,
        },
      ],
    ];

    String selectedPaymentMethod = 'Credit Card';

    return Scaffold(
      appBar: AppBar(
        title: const Text('KZVNT'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/loginpage.jpg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'KZVNT',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final String email = emailController.text;
                    final String password = passwordController.text;

                    if (isValidCredentials(context, email, password)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportScreen(
                            placedOrdersHistory: placedOrdersHistory,
                            selectedPaymentMethod: selectedPaymentMethod,
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Invalid Credentials'),
                            content: const Text(
                                'Please check your email and password.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogPage()),
                    );
                  },
                  child: const Text('Customer Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
