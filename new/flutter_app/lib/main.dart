import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:developer' as developer;
import 'inputToDoTextField.dart';

class Picker extends StatefulWidget {
  const Picker({Key key, this.type}) : super(key : key);

  final Picker type;

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker>{
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());
  List<ToDoData> TodoList = new List<ToDoData>();
  Database m_toDoDB;

  @override
  initState()
  {
    super.initState();
    openDataBase();
    //getData();
  }

  openDataBase() async
  {
    final dbPath = path.join(await getDatabasesPath(), 'todo_database.db');
    m_toDoDB = await openDatabase(
      dbPath,
      onCreate:(db, version){
        return db.execute("CREATE TABLE todo(_index INTEGER PRIMARY KEY, deadline TEXT, brief TEXT, detail TEXT)",);
      },
      version: 1,
    );
    m_toDoDB.execute("CREATE TABLE todo(_index INTEGER PRIMARY KEY, deadline TEXT, brief TEXT, detail TEXT)",);
    //m_toDoDB.delete('todo');
    await getData();
  }



  String get _title{
    return "To do list";
  }

  String get _labelText{
    return DateFormat.yMMMd().format(_fromDate);
  }

  void getData() async {
    final List<Map<String, dynamic>> dataMaps = await m_toDoDB.query('todo');

    //await Future.delayed(Duration(seconds:2));
    //return TodoList;

    TodoList = (List.generate(dataMaps.length, (i){
      developer.log(i.toString());
      return ToDoData(
        index: dataMaps[i]['_index'],
        deadLine: DateTime.now(),
        brief: dataMaps[i]['brief'],
        detail: dataMaps[i]['detail'],
      );
    })
    );

    setState(() {

    });
    //return TodoList;
  }

  Widget buildlist()
  {
    if(TodoList == null)
      return Text("null");

    developer.log(TodoList.toString());
    developer.log(TodoList.length.toString());

    ListView lv = ListView.builder(
        //itemCount: dtList.length,
        shrinkWrap: true,
        //padding: EdgeInsets.all(0.0),
        itemCount: TodoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            //child: Center(child: Text(DateFormat.yMMMd().format(dtList[index]))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child:
                  Column(
                    children: <Widget>[
                      Center(child: Text(DateFormat.yMMMd().format(TodoList[index].deadLine))),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(TodoList[index].brief,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    //m_toDoDB.execute("CREATE TABLE todo(_index INTEGER PRIMARY KEY, deadline TEXT, brief TEXT, detail TEXT)",);
                    int theint = TodoList[index].index;
                    String a = "DELETE FROM todo WHERE _index = $theint";
                    developer.log(a);
                    m_toDoDB.execute(a);
                    TodoList.removeAt(index);
                    setState(() {

                    });
                  },
                ),
              ],
            ) // child: Center(child: Text("gg"))
          );
        }
    );

    developer.log(TodoList.toString());

    return lv;
  }

  void _showInputField () async {
    Object result = await Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context) => inputToDoTextField()),
    );

    ToDoData newTodo = result as ToDoData;
    if(newTodo.detail == null) {
      developer.log("null");
      setState(() {

      });
      return;
    }
    TodoList.add(result as ToDoData);
    await _saveToDB(result as ToDoData);
    developer.log("saved");
    setState(() {

    });
  }

  void _saveToDB(ToDoData _new) async {
    final List<Map<String, dynamic>> dataMaps = await m_toDoDB.query('todo');

    int _indexvalue = 0;
    if(dataMaps.length == 0){
      _indexvalue = 1;
    }
    else {
      Map<String, dynamic> map = dataMaps[dataMaps.length - 1];
      _indexvalue = map["_index"]+1;
    }
    await m_toDoDB.insert(
      'todo',
      _new.toMap(_indexvalue),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            //Text(_labelText),
            const SizedBox(height: 16),
            /*
            new FutureBuilder(
                //future: buildlist(),
                future: this.getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false)
                    //return new Expanded(child: buildlist());
                    //return Text("GET");
                    return CircularProgressIndicator();
                  else if (snapshot.hasError == true) {
                    return Text("ERROR!");
                  }
                  else {
                    return new Expanded(child: buildlist());
                    //return Text("END");
                  }
                }
              ),
             */
            Expanded(
              child: buildlist(),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  IconButton(
                    alignment: Alignment.center,

                    icon: Icon(Icons.add),
                    onPressed: (){
                      //_showDatePicker();
                      _showInputField();
                    },
                  ),
                  IconButton(
                    alignment: Alignment.center,
                    icon: Icon(Icons.delete),
                    onPressed: (){
                      m_toDoDB.delete('todo');
                      m_toDoDB.execute("CREATE TABLE todo(_index INTEGER PRIMARY KEY, deadline TEXT, brief TEXT, detail TEXT)",);
                      TodoList.clear();
                      setState(() {
                      });
                    },
                  )
                ]
              ),
            )
          ],
        ),
      )
    );
  }
}

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Picker(),
    );
  }

}