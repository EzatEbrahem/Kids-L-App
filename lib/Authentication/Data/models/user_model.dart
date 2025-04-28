import 'package:kids_learning/Authentication/Domain/entities/user_entities.dart';

class UserDataModel extends UserData{

  const UserDataModel({required super.userId, required super.name, required super.email, required super.password ,required super.phone, required super.profile});

  factory UserDataModel.fromJson(Map<String,dynamic> json)=>UserDataModel(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      profile: json['profile']
  );
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'profile': profile,
    };
  }

}