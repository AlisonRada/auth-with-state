import 'package:authwithstate/Page/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authwithstate/login_state.dart';
import 'package:authwithstate/Page/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            //state.getCredentials();
            if (state.isLoggedIn()) {
              return Home();
            } else {
              return Login();
            }
          },
        },
      ),
    );
  }

}