import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LoginState with ChangeNotifier {

  bool _loggedIn;
  String _email, _password, _name, _username;
  bool isLoggedIn() => _loggedIn ?? false;
  String getEmail() => _email;
  String getPassword() => _password;
  String getName() => _name;
  String getUserName() => _username;


  login(String email, String password) async{
    print("funcion");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _email = email;
    _password = password;
    Map data = {
      'email': _email,
      'password': _password
    };
    var response = await post("https://movil-api.herokuapp.com/signin", body: data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        _loggedIn = true;
        sharedPreferences.setString("token", jsonResponse['token']);
        sharedPreferences.setString("username", jsonResponse['username']);
        sharedPreferences.setString("email", jsonResponse['email']);
        sharedPreferences.setBool("loggedIn", _loggedIn);
      };
    }else{
      _loggedIn=false;
    }
    notifyListeners();
    return _loggedIn;
  }

  void logout(){
    _loggedIn=false;
    updateLogout(); //Eliminar credenciales
    notifyListeners();
  }

  void updateLogout () async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("email", "");
    prefs.setString("password", "");
    prefs.setBool("loggedIn", false);
  }

  void getCredentials () async{
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool("loggedIn");
    _email = prefs.getString("email");
    _password = prefs.getString("password");
  }

   signUp(name, username, email, password) async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     _name = name;
     _username = username;
     _email = email;
     _password = password;
     Map data = {
       'email': _email,
       'password': _password,
       'username': _username,
       'name': _name
     };
     var response = await post("https://movil-api.herokuapp.com/signup", body: data);
     if (response.statusCode == 200) {
       var jsonResponse = json.decode(response.body);
       if (jsonResponse != null) {
         _loggedIn = true;
         sharedPreferences.setString("token", jsonResponse['token']);
         sharedPreferences.setString("username", jsonResponse['username']);
         sharedPreferences.setString("email", jsonResponse['email']);
         sharedPreferences.setBool("loggedIn", _loggedIn);
       };
       //update();

     }else{
       _loggedIn=false;
     }
     notifyListeners();
     return _loggedIn;
   }


}