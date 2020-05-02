import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:authwithstate/Page/home.dart';
import '../login_state.dart';
import 'signup.dart';

class Login extends StatelessWidget {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  RegExp emailRegExp =
  new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');

  RegExp contRegExp = new RegExp(r'^([1-z0-1@A-Z.\s]{1,255})$');

  String _password, _email;
  String mensaje = '';
  bool _obscureText = true;

  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<LoginState>(context);

    return Scaffold(
      body: state.isLoggedIn() ? Home(mensaje: mensaje) : loginForm(context),
//      body: loginForm(),
    );
  }

  Widget loginForm(BuildContext context) {

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
          return "Su contraseña debe ser al menos de 8 caracteres";
        } else if (!contRegExp.hasMatch(text)) {
          return "El formato para contraseña no es correcto";
        }
        return null;
      },
      onSaved: (val) => _password = val,
      obscureText: _obscureText,
    );

    final loginButon = Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color.fromRGBO(140, 0, 75, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async  {
        if (_key.currentState.validate()) {
          _key.currentState.save();
          var prov = Provider.of<LoginState>(context, listen: false);
          var estado = await prov.login(_email, _password);
          if (estado) {
            mensaje = "Hola, "+prov.getUserName();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(mensaje: mensaje),
              ),
            );
          } else {
            prov.showAlert(context);
          }
          //Una forma correcta de llamar a otra pantalla
        }
      },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    final signup = FlatButton(
      child: Text(
        'Signup',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed:  () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Signup(),
          ),
        );
      }
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
                        emailField,
                        SizedBox(height: 25.0),
                        passwordFormField,
                        SizedBox(height: 35.0),
                        loginButon,
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            forgotLabel,
                            SizedBox(width: 100.0),
                            signup,
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}