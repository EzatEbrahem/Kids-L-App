import 'package:equatable/equatable.dart';

class UserData extends Equatable{
  final String userId;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String profile;

  const UserData({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.profile});

  @override
  // TODO: implement props
  List<Object?> get props => [userId,name,email,password,phone,profile];
}