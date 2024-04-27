import 'package:fitnessapp/manageExerciseMain.dart';
import 'package:fitnessapp/profile.dart';
import 'package:fitnessapp/progressMain.dart';
import 'package:fitnessapp/refreshable.dart';
import 'package:fitnessapp/utils/jwt.dart';
import 'package:fitnessapp/workoutPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'adminMessageScreen.dart';
import 'messageScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget>? _pageOptions;
  // final List<Widget> _pageOptions = [
  //   MessageScreen(),
  //   ProfileScreen(),
  //   ProgressScreen(),
  //   ManageExerciseMain(),
  //   CreateWorkoutScreen(),
  // ];

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    setupScreens();
  }

  Future<void> setupScreens() async {
    String? token = await storage.read(key: 'jwt');
    String role = getUserRoleFromToken(token);

    Widget messageScreen = (role == "admin") ? AdminMessageScreen() : MessageScreen();

    setState(() {
      _pageOptions = [
        messageScreen,
        ProfileScreen(),
        ProgressScreen(),
        ManageExerciseMain(),
        CreateWorkoutScreen(),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Handle the case when _pageOptions is null
    if (_pageOptions == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pageOptions!,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Exercises'),
          BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Create Workout'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}