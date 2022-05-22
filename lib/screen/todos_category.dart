import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;
  const TodosByCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<TodosByCategory> createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = [];
  TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    if (todos is List) {
      todos.forEach((todo) {
        setState(() {
          var model = Todo();
          model.title = todo['title'];
          model.description = todo['description'];
          model.todoDate = todo['todoDate'];
          _todoList.add(model);
        });
      });
    } else {
      setState(() {
        var model = Todo();
        model.title = todos['title'];
        model.description = todos['description'];
        model.todoDate = todos['todoDate'];
        _todoList.add(model);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_todoList[index].title ?? 'No Title')
                          ],
                        ),
                        subtitle: Text(
                            _todoList[index].description ?? 'No Description'),
                        trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
