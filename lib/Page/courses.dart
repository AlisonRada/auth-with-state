import 'package:authwithstate/model/Course.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_state.dart';
import 'package:authwithstate/Page/login.dart';
import 'package:flutter/cupertino.dart';

class CoursesView extends StatefulWidget {

  @override
  _CoursesView createState() => _CoursesView();

//CoursesView({Key key}) : super(key: key);

}


class _CoursesView extends State<CoursesView> {

  List<Course> courses = new List<Course>();

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
    var prov = Provider.of<LoginState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camp Half-blood'),
        backgroundColor: Color.fromRGBO(140, 0, 75, 1),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(140, 0, 75, 1),
              ),
              child: Text(
                'Camp half blood',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: (){
                Provider.of<LoginState>(context, listen: false).logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
            ),

          ],
        ),
      ),
      body: FutureBuilder(
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
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: (){
            prov.addCourse(context);
          },
          backgroundColor: Color.fromRGBO(140, 0, 75, 1),
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
              leading: Icon(Icons.class_, size: 45.0),
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