import 'package:fitnessapp/model/UserUpdate.dart';
import 'package:fitnessapp/refreshable.dart';
import 'package:fitnessapp/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'model/User.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _addressController;
  late TextEditingController _dateOfBirthController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: user?.email);
    _nameController = TextEditingController(text: user?.name);
    _surnameController = TextEditingController(text: user?.surname);
    _addressController = TextEditingController(text: user?.address);
    _dateOfBirthController = TextEditingController(text: user?.dateOfBirth);
    _loadUser();
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime? parseDateString(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }

  Future<void> _loadUser() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    var fetchedUser = await getUser(token!);

    setState(() {
      user = fetchedUser;
      print(user?.dateOfBirth);
      _emailController.text = user!.email;
      _nameController.text = user!.name;
      _surnameController.text = user!.surname;
      _addressController.text = user!.address;
      _dateOfBirthController.text = formatDate(parseDateString(user!.dateOfBirth));
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _showSuccessSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 20),
          Text("Updated successfully!"),
        ],
      ),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 20),
          Text("Saving error!"),
        ],
      ),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to update your profile?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Yes'),
              style: TextButton.styleFrom(primary: Colors.blue),
              onPressed: () async {
                final storage = FlutterSecureStorage();
                String? token = await storage.read(key: 'jwt');
                UserUpdate user = UserUpdate(email: _emailController.text, name: _nameController.text, surname: _surnameController.text, address: _addressController.text, dateOfBirth: _dateOfBirthController.text);
                var response = await updateUser(user.toJson(), token!);
                if (mounted){
                  if (response.statusCode == 204){
                    _showSuccessSnackBar(context);
                  }else{
                    _showErrorSnackBar(context);
                    print('${response.body}: ${response.statusCode}');
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Me'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: 'Surname'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
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
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _showConfirmationDialog();
                    }
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
