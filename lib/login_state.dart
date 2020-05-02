import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {

  bool _loggedIn;
  String _email, _password, _name, _username, _token;
  String _message;
  bool isLoggedIn() => _loggedIn ?? false;
  String getEmail() => _email;
  String getPassword() => _password;
  String getName() => _name;
  String getUserName() => _username;
  String getToken() => _token;

  SharedPreferences prefs;

  update(){
    _username = prefs.getString("username");
    _name = prefs.getString("name");
    _email = prefs.getString("email");
    _token = prefs.getString("token");
    _loggedIn = prefs.getBool("loggedIn");
  }

  login(String email, String password) async{
    prefs = await SharedPreferences.getInstance();
    _email = email;
    _password = password;
    Map data = {
      'email': _email,
      'password': _password
    };
    var response = await post("https://movil-api.herokuapp.com/signin", body: data);
    print(response.statusCode);
    var jsonResponse = json.decode(response.body);
    _message = jsonResponse['error'];
    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        _loggedIn = true;
        prefs.setString("username", jsonResponse['username']);
        prefs.setString("name", jsonResponse['name']);
        prefs.setString("email", jsonResponse['email']);
        prefs.setString("token", jsonResponse['token']);
        prefs.setBool("loggedIn", _loggedIn);
        update();
      };
    }else{
      _loggedIn=false;
    }
    notifyListeners();
    return _loggedIn;
  }

  void logout(){
    _loggedIn=false;
    clearLogged(); //Eliminar credenciales
    notifyListeners();
  }

  void clearLogged () async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("email", null);
    prefs.setString("password", null);
    prefs.setBool("loggedIn", false);
    update();
  }

  void getCredentials () async{
    prefs = await SharedPreferences.getInstance();
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
     var jsonResponse = json.decode(response.body);
     _message = jsonResponse['error'];
     if (response.statusCode == 200) {
       if (jsonResponse != null) {
         _loggedIn = true;
         sharedPreferences.setString("token", jsonResponse['token']);
         sharedPreferences.setString("name", jsonResponse['name']);
         sharedPreferences.setString("username", jsonResponse['username']);
         sharedPreferences.setString("email", jsonResponse['email']);
         sharedPreferences.setBool("loggedIn", _loggedIn);
         update();
       };
       //update();

     }else{
       _loggedIn=false;
     }
     notifyListeners();
     return _loggedIn;
   }

  void showAlert(BuildContext context) {
    var alert = new AlertDialog(
      content: Container(
        child: Row(
          children: <Widget>[Text(_message)],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }


}