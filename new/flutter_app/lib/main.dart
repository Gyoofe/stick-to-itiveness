import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Picker extends StatefulWidget {
  const Picker({Key key, this.type}) : super(key : key);

  final Picker type;

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker>{
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());
  List<DateTime> dtList = [DateTime.now()];

  String get _title{
    return "To do list";
  }

  String get _labelText{
    return DateFormat.yMMMd().format(_fromDate);
  }

  Widget buildlist()
  {
    ListView lv = ListView.builder(
        itemCount: dtList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text(DateFormat.yMMMd().format(dtList[index]))),
          );
        }
    );
    return lv;
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _fromDate,
        firstDate: DateTime(2015, 1),
        lastDate: DateTime(2100),
    );
    setState(() {
      _fromDate = picked;
      dtList.add(picked);
    });
  }

  void _showInputField () {
    Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context){
        return inputToDoTextField();
      })
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
          mainAxisSize: MainAxisSize.min,
          children: [
            //Text(_labelText),
            const SizedBox(height: 16),
            new Expanded(
                child: buildlist()
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                //_showDatePicker();
                _showInputField();
              },
            ),
          ],
        ),
      )
    );
  }
}

void main() {
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

class inputToDoTextField extends StatelessWidget {
  const inputToDoTextField();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading - leading(제목앞에 표시할 Widget)이 Null인 경우 leading을 자동적으로 추론할것인지?
        automaticallyImplyLeading: true,
        title: Text("새 할일 추가"),
      ),
      body: const inputForm(),
    );
  }
}

class inputForm extends StatefulWidget{
  const inputForm({Key key}) : super(key: key);

  @override
  inputFormState createState() => inputFormState();
}

class ToDoData{
  DateTime deadLine;
  String brief;
  String detail;
}

class inputFormState extends State<inputForm>{
  ToDoData m_todo = ToDoData();
  DateTime _fromDate = DateTime.now();
  final m_formKey = GlobalKey<FormState>();

  void _handleSubmitted() {
    if (m_formKey.currentState.validate()){
      m_formKey.currentState.save();
      Navigator.pop(context);
    }
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    setState(() {
      _fromDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    const spaceBox = SizedBox(height: 24);
    return Scaffold(
      body:
        Form(
          key: m_formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   spaceBox,
                   Row(
                     children: [
                       Text(
                           DateFormat.yMMMd().format(_fromDate),
                       ),
                       IconButton(
                         icon: Icon(Icons.add_alarm),
                         onPressed: _showDatePicker,
                       )
                     ],
                   ),
                   spaceBox,
                   TextFormField(
                     decoration: InputDecoration(
                       border: const OutlineInputBorder(),
                       labelText: "할 일",
                     ),
                     maxLines: 1,
                     onSaved: (String _value) {
                       m_todo.brief = _value;
                     },
                     validator: (String value){
                       if (value.isEmpty == true){
                         return '할 일을 입력해 주세요.';
                       }
                       return null;
                     },
                   ),
                   spaceBox,
                   TextFormField(
                     decoration: InputDecoration(
                       border: const OutlineInputBorder(),
                       labelText: "상세",
                     ),
                     maxLines: 3,
                     onSaved: (String _value){
                       m_todo.detail = _value;
                     },
                   ),
                   spaceBox,
                   Center(
                     child:IconButton(
                       icon: Icon(Icons.check),
                       onPressed: _handleSubmitted,
                     ),
                   )
                 ],
              ),
            ),
          ),
        ),
    );
  }
}