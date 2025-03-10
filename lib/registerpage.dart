import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();

    void showRegisterDialog(String email, String password) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registration Successful'),
            content: Text(
                'Your registration is successful.\n\nEmail: $email\nPassword: $password\n\nPlease use these credentials to log in.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    Future<void> registerUser(String fullName, String email) async {
      final url = Uri.parse('http://192.168.56.1/app/register_user.php');

      try {
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: <String, String>{
            'name': fullName,
            'email': email,
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            final String email = data['username'];
            final String password = data['password'];
            showRegisterDialog(email, password);
          } else {
            showError('Error: ${data['message']}');
          }
        } else {
          showError('Failed to register user: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
        showError('Error registering user: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/register.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final String email = emailController.text;
                  final String fullName = fullNameController.text;

                  if (email.isEmpty) {
                    showError('Please enter your email');
                  } else if (fullName.isEmpty) {
                    showError('Please enter your full name');
                  } else {
                    await registerUser(fullName, email);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
