import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {

  bool _loggedIn;
  String _email, _password;
  bool isLoggedIn() => _loggedIn ?? false;
  String getEmail() => _email;
  String getPassword() => _password;


  void login(){
    _loggedIn= true;
    update();
    notifyListeners();
  }

  void logout(){
    _loggedIn=false;
    update();
    notifyListeners();
  }

  void update () async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("email", _email);
    prefs.setString("password", _password);
    prefs.setBool("loggedIn", _loggedIn);
  }

  void getCredentials () async{
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool("loggedIn");
    _email = prefs.getString("email");
    _password = prefs.getString("password");
  }

  void signUp(email, password){
    _loggedIn = true;
    _email = email;
    _password = password;
    update();
    notifyListeners();
  }

}