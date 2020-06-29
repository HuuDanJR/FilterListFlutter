class User{
  String name;
  String email;
  int id;

  User({this.id,this.name, this.email});
  factory User.fromJson(Map<String, dynamic> json ){
    return User(
      id: json["id"] as int,
      name: json["name"] as String,
      email: json["email"] as String,
    );
  }
}