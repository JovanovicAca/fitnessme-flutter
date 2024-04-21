class UserUpdate {
  String email;
  String name;
  String surname;
  String address;
  String dateOfBirth;

  UserUpdate({
    required this.email,
    required this.name,
    required this.surname,
    required this.address,
    required this.dateOfBirth,
});
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'address': address,
      'date_of_birth': dateOfBirth,
    };
  }
}