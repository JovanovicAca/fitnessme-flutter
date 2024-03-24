import 'package:fitnessapp/loginPage.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FitnessMe());
}

class FitnessMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          //FIXME: ovde appbar samo ima ako se dolazi iz pocetne strane, nema ako se dodje iz registracije
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: BasePage(child: LoginPage()),
    );
  }
}

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Me'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: child,
    );
  }
}
