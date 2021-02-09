import 'package:flutter/material.dart';
import 'package:sqflite_demo/models/Todo.dart';
import 'package:sqflite_demo/screens/todolistdetail.dart';
import 'package:sqflite_demo/util/dbhelper.dart';


class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DbHelper dbHelper = DbHelper();
  List<Todo> todos;
  int countList;

  @override
  Widget build(BuildContext context) {
    if(todos==null){
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('List Working'),
        centerTitle: true,
      ),
      body: listViewItems(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new Todo',
        onPressed: (){
          Todo todo = Todo('','',null,3);
          navigateTodo(todo);
        },
        child: Icon(Icons.add),
      ),
    );
  }
  ListView listViewItems() {
    if(countList!=null)
    return ListView.builder(
        itemCount: countList,
        itemBuilder: (BuildContext context,int position)
        {
          return Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              title: Text(this.todos[position].title),
              leading: CircleAvatar(
                backgroundColor: this.todos[position].getColorPriority(),
                child: Text(this.todos[position].priority.toString()),
              ),
              subtitle: Text(this.todos[position].date),
              onTap: (){
                debugPrint('On Tap $position');
                navigateTodo(this.todos[position]);
              },
            ),
          );
        }
    ); else return null;
  }

  void getData() {
    final db = dbHelper.initilizeDb();
    db.then((value){
        final todosFeature = dbHelper.getListTodos();
        todosFeature.then((value){
          List<Todo> todoList  = List<Todo>();
          int count = value.length;
          for(int i = 0; i<count ; i++)
              todoList.add(Todo.fromObject(value[i]));
          setState(() {
            todos = todoList;
            countList = count;
          });
        });
  }
  );
}
  void navigateTodo(Todo todo) async{
    var result = await Navigator.push(context,MaterialPageRoute(builder: (context)=>TodoListDetail(todo)));
    if(result==true) getData();
  }
}
