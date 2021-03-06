import 'package:authwithstate/Page/courses.dart';
import 'package:authwithstate/Page/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authwithstate/login_state.dart';
import 'package:authwithstate/Page/login.dart';
import 'package:authwithstate/Page/screensplash.dart';

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
            state.getCredentials();
            state.update();
            if (state.isLoaded()) {
              if (state.isLoggedIn()) {
                return CoursesView();//Home();
              } else {
                return Login();
              }
            } else {
              return SplashScreen();
            }
          },
        },
      ),
    );
  }

}