class User {
  String email;
  String password;
  String name;
  String surname;
  String address;
  String dateOfBirth;
  String role;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
    required this.address,
    required this.dateOfBirth,
    this.role = 'user', // Default value for role
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'address': address,
      'date_of_birth': dateOfBirth,
      'role': role,
    };
  }
}
