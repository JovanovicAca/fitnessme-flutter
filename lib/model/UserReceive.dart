class UserReceive {
  String id;
  String email;
  String name;

  UserReceive({
    required this.id,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory UserReceive.fromJson(Map<String, dynamic> json) {
    return UserReceive(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
