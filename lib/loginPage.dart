import 'dart:convert';

import 'package:fitnessapp/register.dart';
import 'package:flutter/material.dart';
import 'navigationBottom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _credentialsError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              if (_credentialsError)
                const Center(
                  child: Text(
                    'Invalid email or password',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: Text('Login'),
                onPressed: () async {
                   if (_formKey.currentState!.validate()) {
                  var data = {
                    'email': _emailController.text,
                    'password': _passwordController.text,
                  };
                  String body = json.encode(data);
                  try {
                    // Send the POST request
                    var response = await http.post(
                      Uri.parse('http://192.168.0.110:3000/user/login'),
                      headers: {"Content-Type": "application/json"},
                      body: body,
                    );
                    if (mounted) {
                        if (response.statusCode == 200) {
                      String? token =
                          response.headers['authorization']?.split(' ').last;
                      // String token = "token";
                      if (token != null && token.isNotEmpty) {
                        await storage.write(key: 'jwt', value: token);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      } else {
                        print(response.headers['authorization']);
                        print("Error with token retrieving");
                        return;
                      }
                         } else {
                        setState(() {
                          _credentialsError = true;
                        });
                      }
                    }
                  } catch (exception) {
                    print('Failed to login user: $exception');
                  }
                    }
                },
                style: TextButton.styleFrom(
                    primary: Colors.blue,
                    textStyle: const TextStyle(fontSize: 18)),
              ),
              TextButton(
                onPressed: () {
                  //TODO: Implement your forgot password logic here
                },
                style: TextButton.styleFrom(
                  primary: Colors.blue, // Text color
                ),
                child: const Text('Forgot Password?'),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                style: TextButton.styleFrom(
                    primary: Colors.blue, // Text color
                    textStyle: const TextStyle(fontSize: 18)),
                child: const Text("Don't have an account? Register here!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
