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

  final _key = GlobalKey<FormState>();

  Widget prueba(BuildContext context) {

    var emailFormField = TextFormField(
      validator: (text) {
        if (text.isEmpty) {
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

    var passwordFormField = TextFormField(
      style: style,
      decoration: InputDecoration(
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          //hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (text) {
        if (text.isEmpty) {
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

    var loginButon = Material(
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

    var forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    var signup = FlatButton(
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

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Camp Half-blood'),
          backgroundColor: Color.fromRGBO(140, 0, 75, 1),
        ),
        body: SafeArea(
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      Icon(Icons.school,
                        size: orientation == Orientation.portrait ? 150.0 : 80.0,
                        color: Color.fromRGBO(140, 0, 75, 1),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Form(child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: emailFormField,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: passwordFormField,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          loginButon,
                        ],
                      )
                      ),
                      signup,
                      SizedBox(
                        height: 50.0,
                      ),
                      Center(child: forgotLabel)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<LoginState>(context);

    return Scaffold(
      body: state.isLoggedIn() ? Home(mensaje: mensaje) : prueba(context),
//      body: loginForm(),
    );
  }

  Widget loginForm(BuildContext context) {

    var emailField = TextFormField(
      validator: (text) {
        if (text.isEmpty) {
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

    var passwordFormField = TextFormField(
      style: style,
      decoration: InputDecoration(
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          //hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (text) {
        if (text.isEmpty) {
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

    var loginButon = Material(
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

    var forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    var signup = FlatButton(
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
          height: MediaQuery.of(context).size.height,
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