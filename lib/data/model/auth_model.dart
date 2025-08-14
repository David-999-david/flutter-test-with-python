class RegisterModel {
  final String name;
  final String email;
  final String phone;
  final String passowrd;

  RegisterModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.passowrd,
  });

  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "phone": phone, "password": passowrd};
  }
}
