import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screen/todo_screen.dart';
import 'package:todo_app/services/todo_service.dart';

import '../helpers/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService? _todoService;

  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = [];
    var todos = await _todoService?.readTodos();
    if (todos is List) {
      todos.forEach((todo) {
        setState(() {
          var model = Todo();
          model.id = todo['id'];
          model.description = todo['description'];
          model.title = todo['title'];
          model.category = todo['category'];
          model.todoDate = todo['todoDate'];
          model.isFinished = todo['isFinished'];
          _todoList.add(model);
        });
      });
    } else {
      var model = Todo();
      model.id = todos['id'];
      model.description = todos['description'];
      model.title = todos['title'];
      model.category = todos['category'];
      model.todoDate = todos['todoDate'];
      model.isFinished = todos['isFinished'];
      _todoList.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.amber,
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(_todoList[index].title ?? 'No Title')],
                    ),
                    subtitle: Text(_todoList[index].category ?? 'No Category'),
                    trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                  )),
            );
          }),
    );
  }
}
