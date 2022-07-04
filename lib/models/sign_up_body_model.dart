class SignUpBody {
  String name;
  String phone;
  String email;
  String password;

  SignUpBody({
    required this.email, required this.name, required this.password, required this.phone
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}