import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String plan;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.plan,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      plan: json['plan'] ?? 'free',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'plan': plan,
      'token': token,
    };
  }
}

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  void setUser(Map<String, dynamic> userData) {
    _user = UserModel.fromJson(userData);
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  String? get token => _user?.token;
  String? get userName => _user?.name;
  String? get userEmail => _user?.email;
  String? get userAvatar => _user?.avatar;
  bool get isPremium => _user?.plan == 'premium';
}
