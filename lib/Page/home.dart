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

  final String mensaje;
  Home({Key key, @required this.mensaje}) : super(key: key);
  List<Course> courses = new List<Course>();
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

    var prov = Provider.of<LoginState>(context, listen: false);
    getCourses(prov.getUserName(), context);
    print(courses.length);

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
          child: _list(),
        ),
      ),
    );
  }

  Widget _list(  ) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, posicion) {
        var element = courses[posicion];
        return _item(element, posicion, context);
      },
    );
  }



  Widget _item(Course element, int posicion, BuildContext context) {
    return Dismissible(key: UniqueKey(),
      onDismissed: (direction) {
          courses.removeAt(posicion);
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
    if (courses[posicion].completed == 0) {
      courses[posicion].completed = 1;
    } else{
      courses[posicion].completed = 0;
    }
  }

  addCourse(String user, BuildContext context) async {
    final uri = "https://movil-api.herokuapp.com/"+user+"/courses";
    final response = await post(
      uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " +
          Provider.of<LoginState>(context, listen: false).getToken(),
    },);
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (!jsonResponse == null) {
        int id = int.parse(jsonResponse['id'].toString());
        String name = jsonResponse['name'].toString();
        String professor = jsonResponse['professor'].toString();
        int students= int.parse(jsonResponse['students'].toString());
        int completed=0;
        Course course= new Course(id: id, name: name, professor: professor,
            students:students, completed: completed);
        courses.add(course);
      }
    }else{
      String message = jsonResponse['error'];
      print("Respuesta");
      print(jsonResponse);
      return null;
    }
  }
  getCourses(String user, BuildContext context) async {
    final uri = "https://movil-api.herokuapp.com/"+user+"/courses";
    final response = await get(
      uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer " +
          Provider.of<LoginState>(context, listen: false).getToken(),
    },);
    var jsonResponse = json.decode(response.body);
    print("json");
    print(jsonResponse[0]);
    if (response.statusCode == 200) {
      for(Map i in jsonResponse){
        Course cr = new Course(id: int.parse(i["id"]),name: i["name"],
        professor: i["professor"], students: int.parse(i["students"]),
            completed: 0);
        courses.add(cr);
        print(cr);
      }
    }else{
      String message = jsonResponse['error'];
      print("Respuesta");
      print(jsonResponse);
      return null;
    }
  }

}







