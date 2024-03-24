import 'package:fitnessapp/manageExerciseMain.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pageOptions = [
    // HomeScreen(),
    // ProfileScreen(),
    // ProgressScreen(),
    ManageExerciseMain(),
    // CreateWorkoutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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
// class NavigationBottom extends StatefulWidget {
//   @override
//   _NavigationBottomState createState() => _NavigationBottomState();
// }
//
// class _NavigationBottomState extends State<NavigationBottom> {
//   int _selectedIndex = 0;
//
//   // static final List<Widget> _widgetOptions = <Widget>[
//   //   const Text('Home/Dashboard Page',
//   //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
//   //   const Text('Profile Page',
//   //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
//   //   const Text('Progress Page',
//   //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
//   //   const Text('Exercises Page',
//   //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
//   //   const Text('Workout Creation Page',
//   //       style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
//   // ];
//
//   final List<Widget> _pageOptions = [
//     // HomeScreen(), // Replace with your actual home screen widget
//     // ProfileScreen(), // Replace with your actual profile screen widget
//     // ProgressScreen(), // Replace with your actual progress screen widget
//     ManageExerciseMain(), // Your existing exercise screen
//     // CreateWorkoutScreen(), // Replace with your actual workout creation screen
//   ];
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (_selectedIndex == 3) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ManageExerciseMain()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Fitness Me'),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.blue, // AppBar color
//       // ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Add your onPressed code here!
//           print('Messaging button pressed');
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.message),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: 'Progress',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center),
//             label: 'Exercises',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.create),
//             label: 'Create Workout',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }
