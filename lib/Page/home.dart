import 'package:authwithstate/model/Course.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';
import 'package:authwithstate/Page/login.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Home extends StatelessWidget {

  List<Course> courses = new List<Course>();
  final String mensaje;

  Home({Key key, @required this.mensaje}) : super(key: key);
  Widget no(BuildContext context) {

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
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: new Alignment(1.0, 0.0), // 10% of the width, so there are ten blinds.
            colors: [Colors.white, Colors.pinkAccent], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
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
          child: body,//_list(context),
        ),
      ),
    );
  }

  Future <List<Course>> getCoursesList (BuildContext context) async {
    var prov = Provider.of<LoginState>(context, listen: false);
    prov.getCourses();
    if(prov.already()){
      print('already: '+prov.already().toString());
      prov.setAlready();
      courses.clear();
      List<Course> courses_ = prov.getCoursesList();
      courses.addAll(courses_);
    }
    return courses;
  }

  @override
  Widget build(BuildContext context) {

    final home_btn = RaisedButton(
      child: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: new Alignment(1.0, 0.0), // 10% of the width, so there are ten blinds.
            colors: [Colors.white, Colors.pinkAccent], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
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

    var prov = Provider.of<LoginState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camp Half-blood'),
        backgroundColor: Color.fromRGBO(140, 0, 75, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: getCoursesList(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var element = snapshot.data[index];
                      return _item(element, index, context);
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text('Loading'),
                    ),
                  );
                }
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: home_btn,
                ),
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: (){
            prov.addCourse(context);
          },
          tooltip: 'Create course',
          child: new Icon(Icons.add)
      ),
    );
  }

  Widget _item(Course element, int posicion, BuildContext context) {
    return Dismissible(key: UniqueKey(),
      onDismissed: (direction) {
        //courses.removeAt(posicion);
      },
      background: Container(color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child:
          Text("Deleting",
              style: TextStyle(fontSize: 15, color: Colors.white)
          ),
        ),
      ),
      child: Container(
        padding: new EdgeInsets.all(7.0),
        height: 100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: element.completed == 1 ? Colors.blueGrey : Colors.white70,
          child: Center(
            child: ListTile(
              leading: Icon(Icons.account_box, size: 45.0),
              title: Text(element.id.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(element.name),
              isThreeLine: true,
              onTap: ()=>_onTap(context, element, posicion),
            ),
          ),
        ),
      ),
    );
  }


  void _onTap(BuildContext context, Course location, int posicion ) {
    /*if (courses[posicion].completed == 0) {
      courses[posicion].completed = 1;
    } else{
      courses[posicion].completed = 0;
    }*/
  }

}