import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_state.dart';
import 'package:authwithstate/Page/login.dart';

class Home extends StatelessWidget {

  final String mensaje;

  const Home({Key key, @required this.mensaje}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        mensaje ?? "Welcome again",
        style: TextStyle(fontSize: 28.0, color: Colors.black),
      ),
    );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );

    final home_btn = RaisedButton(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.pink[600],
            Colors.pink[900],
          ]),
        ),
        padding: const EdgeInsets.all(10.0),
        child: const Text(
            'Logout',
            style: TextStyle(fontSize: 20)
        ),
      ),
      textColor: Colors.white,
      onPressed: () async {
        Provider.of<LoginState>(context, listen: false).logout();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      },
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.pink[50],
          Colors.pink[300],
        ]),
      ),
      child: Column(
        children: <Widget>[welcome, lorem, home_btn],
      ),
    );


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
          child: body,
        ),
      ),
    );
  }

}