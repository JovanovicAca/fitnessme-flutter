import 'dart:convert';

import 'package:fitnessapp/loginPage.dart';
import 'package:fitnessapp/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'model/User.dart';

class Register extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Me'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can\'t be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can\'t be empty';
                }
                if (value.length < 5) {
                  return 'Password length must be over 5 characters!';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can\'t be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(
                labelText: 'Surname',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can\'t be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dateOfBirthController,
              decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: Icon(Icons.calendar_today)),
              onTap: () {
                _selectDate(context);
              },
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can\'t be empty';
                }
                if (DateTime.parse(value).year > DateTime.now().year - 15) {
                  return 'You must be 15 years old';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Register'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var user = User(
                    email: _emailController.text,
                    password: _passwordController.text,
                    name: _nameController.text,
                    surname: _surnameController.text,
                    address: _addressController.text,
                    dateOfBirth: _dateOfBirthController.text,
                  );
                  // String body = json.encode(user.toJson());
                  try {
                    var response = await registerUser(user.toJson());

                    if (mounted) {
                      if (response.statusCode == 201) {
                        print('User registered successfully');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      } else if (response.statusCode == 209) {
                        print('Email already exists');
                      } else {
                        print('Failed to register user');
                      }
                    }
                  } catch (exception) {
                    print('Failed to register user: $exception');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  } 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
