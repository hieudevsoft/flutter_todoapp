import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_demo/models/Todo.dart';
import 'package:sqflite_demo/util/dbhelper.dart';

DbHelper helper = DbHelper();
final List<String> choices = const <String>['Save Todo & Back','Delete Todo','Back To List'];
const menuSave = 'Save Todo & Back';
const menuDelete = 'Delete Todo';
const menuBack = 'Back To List';
class TodoListDetail extends StatefulWidget {
  final Todo todo;
  TodoListDetail(this.todo);
  @override
  _TodoListDetailState createState() => _TodoListDetailState(todo);
}

class _TodoListDetailState extends State<TodoListDetail> {
  Todo todo;
  _TodoListDetailState(this.todo);
  final List<String> _priorities =['High','Medium','Low'];
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    title.text = todo.title;
    description.text = todo.description;
    var textStyle = Theme.of(context).textTheme.subtitle1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: [
          PopupMenuButton(
          onSelected: select,
          itemBuilder: (context)=>choices.map((e) => PopupMenuItem(child: Text('$e'),value: e)).toList())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children:[ Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,20),
                  child: TextField(
                    onChanged: (value)=>updateTitle(),
                    controller: title,
                    style: textStyle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,20),
                  child: TextField(
                    controller: description,
                    style: textStyle,
                    onChanged: (value)=>updateDescription(),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0))
                        )
                    ),
                  ),
                ),
                ListTile(
                  title: DropdownButton<String>(
                      items: _priorities.map((String item){
                        return DropdownMenuItem<String>(
                            child: Text(item),
                            value: item,

                           );
                      }).toList(),
                      style: textStyle,
                      value: retrievePriority(todo.priority),
                      onChanged: updatePriority),
                )
              ],
            ),
          )],
        ),
      ),
    );
  }
  void select(String value) async{
    int result;
    switch(value){
      case menuSave:save();break;
      case menuDelete:
        Navigator.pop(context,true);
        if(todo.id==null) return;
        result = await helper.delete(todo);
        if(result>0) {
          var alertDialog = AlertDialog(
            title: Text('Delete ${todo.title}'),
            content: Text('The Todo has been deleted'),
          );
          showDialog(context: context,builder: (_)=>alertDialog);
        }
        break;
      case menuBack:Navigator.pop(context,true);break;
      default:
    }
  }
  void save(){
    todo.date = DateFormat.yMd().format(DateTime.now()).toString();
    if(todo.id!=null) helper.update(todo); else helper.insert(todo);
    Navigator.pop(context,true);
  }
  void updatePriority(String value){
    switch(value){
      case 'High':todo.priority = 1;break;
      case 'Medium':todo.priority = 2;break;
      case 'Low':todo.priority = 3;break;
    }
  }

  String retrievePriority(int value){ return _priorities[value-1] ;}
  void updateTitle()=>todo.title = title.text;
  void updateDescription()=>todo.description = description.text;
}
