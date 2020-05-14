import 'package:authwithstate/Page/courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';
import 'signup.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camp Half-blood'),
        backgroundColor: Color.fromRGBO(140, 0, 75, 1),
      ),
      body: Center(
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget child) {
            return child;
          },
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  RegExp emailRegExp =
  new RegExp(r'^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$');

  RegExp contRegExp = new RegExp(r'^([1-z0-1@A-Z.\s]{1,255})$');
  RegExp contNumExp = new RegExp('[a-zA-Z]');

  GlobalKey<FormState> _key = GlobalKey();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void initState(){
    final prov = Provider.of<LoginState>(context, listen: false);
    if(prov.isRemembered()){
      emailController.text = prov.getEmail();
      passwordController.text = prov.getPassword();
      rememberMe = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final emailFormField = TextFormField(
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
      controller: emailController,
      decoration: InputDecoration(
          counterText: '',
          labelText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          //hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordFormField = TextFormField(
      style: style,
      controller: passwordController,
      decoration: InputDecoration(
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
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
    );

    return Material(
      child: Scaffold(
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
                      Form(
                        key: _key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: emailFormField,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: passwordFormField,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Material(
                                  elevation: 3.0,
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Color.fromRGBO(140, 0, 75, 1),
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    onPressed: () async{
                                      if (_key.currentState.validate()) {
                                        _key.currentState.save();
                                        var prov = Provider.of<LoginState>(context, listen: false);
                                        prov.setRemember(rememberMe);
                                        var status= await prov.login(emailController.text, passwordController.text);
                                        if(status==true) {
                                          var mensaje = "Hola, "+prov.getUserName();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CoursesView(),
                                            ),
                                          );
                                        }else{
                                          prov.showAlert(context);
                                        };
                                      }
                                    },
                                    child: Text("Login",
                                        textAlign: TextAlign.center,
                                        style: style.copyWith(
                                            color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(value: rememberMe,
                                    activeColor: Color.fromRGBO(140, 0, 75, 1),
                                    onChanged:(bool newValue) {
                                      setState(() {
                                        rememberMe = newValue;
                                      });
                                    }),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                SizedBox(
                                  width: 100.0,
                                ),
                                FlatButton(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => Signup()));
                                      },
                                      child: Text(
                                        'SignUp',
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      )

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
}