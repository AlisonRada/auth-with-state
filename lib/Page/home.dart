import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_state.dart';
import 'package:authwithstate/Page/login.dart';

class Home extends StatelessWidget {

  final String mensaje;

  static Route<dynamic> route(String mensaje) {
    return MaterialPageRoute(
      builder: (context) => Home(mensaje: mensaje),
    );
  }

  const Home({Key key, @required this.mensaje}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget child) {
            return child;
          },
          child: RaisedButton(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                  'HOME PAGE',
                  style: TextStyle(fontSize: 20)
              ),
            ),
            textColor: Colors.white,
            onPressed: () async {
              Provider.of<LoginState>(context, listen: false).logout();
              Navigator.of(context).push(Login.route());
            },
          ),
        ),
      ),
    );
  }
}