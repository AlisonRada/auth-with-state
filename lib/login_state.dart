import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/Course.dart';

class LoginState with ChangeNotifier {

  SharedPreferences prefs;

  List<Course> courses = new List<Course>();

  bool _loggedIn, _loaded = false, _rememberMe = false, _needList = true, _already = false;
  String _email, _password, _name, _username, _token;
  String _message;
  bool isLoggedIn() => _loggedIn ?? false;
  bool isLoaded() => _loaded ?? false;
  bool isRemembered() => _rememberMe;
  bool needList()=> _needList;
  bool already() => _already;
  String getEmail() => _email ?? "";
  String getPassword() => _password ?? "";
  String getName() => _name ?? "";
  String getUserName() => prefs.getString("username") ?? "";
  String getToken() => prefs.getString("token") ?? "";

  List<Course> getCoursesList() => courses;

  void setRemember(value) => _rememberMe = value;
  void setAlready() => _already = !_already;


  update() async{
    prefs = await SharedPreferences.getInstance();
    _username = prefs.getString("username");
    _name = prefs.getString("name");
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
    print("Login status code: "+response.statusCode.toString());
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        _loggedIn = true;
        prefs.setString("username", jsonResponse['username']);
        prefs.setString("name", jsonResponse['name']);
        prefs.setString("email", jsonResponse['email']);
        prefs.setString("token", jsonResponse['token']);
        prefs.setString("password", password);
        prefs.setBool("loggedIn", _loggedIn);
        print("Nuevo token");
        print(prefs.getString("token"));
        update();
      };
    }else{
      _message = jsonResponse['error'];
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
    prefs.setString("name", null);
    prefs.setString("username", null);
    prefs.setBool("loggedIn", false);
    update();
  }

  void getCredentials () async{
    prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool("loggedIn");
    _email = prefs.getString("email");
    _password = prefs.getString("password");
    _loaded = true;
    notifyListeners();
  }

  signUp(email, password, username, name) async {
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
    print(response.statusCode);
    var jsonResponse = json.decode(response.body);
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
    }else{
      _message = jsonResponse['error'];
      _loggedIn=false;
      print("Respuesta");
      print(jsonResponse);
    }
    notifyListeners();
    return _loggedIn;
  }

  void showAlert(BuildContext context) {
    var alert = new AlertDialog(
      content: Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(_message)
            )
          ],
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

  //Return false if user must sign in again or true if not.
  checkTokenValidity() async {
    final uri = "https://movil-api.herokuapp.com/check/token";
    final response = await post(
      uri, headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " + getToken(),
    },
    );
    var jsonResponse = json.decode(response.body);
    if(response.statusCode == 200){
      if(!jsonResponse['valid']){
        //Marco la opción recordado así que solicito otro token
        if(_rememberMe){
          print("Token");
          print(getToken());
          print("El token no es válido");
          print(getEmail());
          print(getPassword());
          login(getEmail(), getPassword());
          return true;
        } else{
          //Necesita iniciar manualmente para obtener otro token
          _message = "Su periodo expiró, debe volver a iniciar sesión.";
          return false;
        }
      } else{
        print("El token sigue siendo válido válido");
        return true;
      }
    }
  }

  getCourses() async {
    var user = "martha1";//getUserName();
    if(_needList){
      courses.clear();
      _needList = false;
      final uri = "https://movil-api.herokuapp.com/"+user+"/courses";
      final response = await get(
        uri, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " +
            getToken(),
      },);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        for(Map i in jsonResponse){
          Course cr = new Course(id: int.parse(i["id"].toString()),name: i["name"],
              professor: i["professor"], students: int.parse(i["students"].toString()),
              completed: 0);
          courses.add(cr);
          //print(cr.name);
        }
      }else{
        String message = jsonResponse['error'];
        print("Respuesta");
        print(jsonResponse);
        return null;
      }
      _already = true;
    }
  }

  addCourse(BuildContext context) async {
    var user = _username;
    final uri = "https://movil-api.herokuapp.com/"+user+"/courses";
    final response = await post(
      uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " +
          getToken(),
    },);
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      int id = int.parse(jsonResponse['id'].toString());
      String name = jsonResponse['name'].toString();
      String professor = jsonResponse['professor'].toString();
      int students= int.parse(jsonResponse['students'].toString());
      int completed=0;
      Course course= new Course(id: id, name: name, professor: professor,
          students:students, completed: completed);
      courses.add(course);
      setAlready();
      print('new size: '+courses.length.toString());
    }else{
      String message = jsonResponse['error'];
      print("Respuesta");
      print(jsonResponse);
    }
  }
}