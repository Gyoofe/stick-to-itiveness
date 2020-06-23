import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:developer' as developer;

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
      body: inputForm(),
    );
  }
}

class inputForm extends StatefulWidget{
  inputForm({Key key}) : super(key: key);

  @override
  inputFormState createState() => inputFormState();
}

class ToDoData{
  DateTime deadLine;
  String brief;
  String detail;
  int index;

  ToDoData({this.index, this.deadLine, this.brief, this.detail});

  Map<String, dynamic> toMap(int _index) {
    String date = DateFormat.yMMMd().format(deadLine);
    return {
      '_index' : _index,
      'deadLine' : date,
      'brief' : brief,
      'detail' : detail,
    };
  }
}

class inputFormState extends State<inputForm>{
  inputFormState();
  ToDoData m_todo = ToDoData();
  DateTime _fromDate = DateTime.now();
  final m_formKey = GlobalKey<FormState>();

  void insertTodoToDatabase(ToDoData _todo) async {
    //final List<Map<String, dynamic>> dataMaps = await db.query('todo');

    //developer.log(dataMaps.length.toString(), name: "before insert");
    m_todo.deadLine = _fromDate;
    /*await db.insert(
      'todo',
      _todo.toMap(dataMaps.length),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    */
  }

  void _handleSubmitted() {
    if (m_formKey.currentState.validate()){
      m_formKey.currentState.save();
      m_todo.deadLine = _fromDate;
      //insertTodoToDatabase(m_todo);
      Navigator.pop(context, m_todo);
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