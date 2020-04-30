import 'package:authwithstate/Page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import 'package:authwithstate/login_state.dart';

//import '../login_state.dart';

class Signup extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  RegExp emailRegExp =
  new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');

  RegExp contRegExp = new RegExp(r'^([1-z0-1@A-Z.\s]{1,255})$');

  GlobalKey<FormState> _key = GlobalKey();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {

    final nameField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: 'Name',
          hintText: "Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailField = TextFormField(
      validator: (text) {
        if (text.length == 0) {
          return "Este campo correo es requerido";
        } else if (!emailRegExp.hasMatch(text)) {
          return "El formato para correo no es correcto";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      maxLength: 50,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          counterText: '',
          labelText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          //hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onSaved: (text) => _email = text,
    );

    final passwordFormField = TextFormField(
      style: style,
      decoration: InputDecoration(
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          //hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (text) {
        if (text.length == 0) {
          return "Este campo contraseña es requerido";
        } else if (text.length < 8) {
          return "Su contraseña debe ser al menos de 5 caracteres";
        } else if (!contRegExp.hasMatch(text)) {
          return "El formato para contraseña no es correcto";
        }
        return null;
      },
      obscureText: true,
      onSaved: (text) => _password= text,
    );

    final signUpButon = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(140, 0, 75, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            if (_key.currentState.validate()) {
              _key.currentState.save();

              Provider.of<LoginState>(context, listen: false).login();

              //Una forma correcta de llamar a otra pantalla
              Navigator.of(context).push(Home.route(""));
            }
          },
        child: Text("Sign up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camp Half-blood'),
        backgroundColor: Color.fromRGBO(140, 0, 75, 1),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 155.0,
                        child: Icon(Icons.school,
                          size: 150.0,
                          color: Color.fromRGBO(140, 0, 75, 1),
                        )
                    ),
                    SizedBox(height: 45.0),
                    Form(
                      key: _key,
                      child: Column(
                        children: <Widget>[
                          nameField,
                          SizedBox(height: 18.0),
                          emailField,
                          SizedBox(height: 18.0),
                          passwordFormField,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    signUpButon,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}