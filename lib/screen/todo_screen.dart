import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo.dart';

import 'package:todo_app/services/category_service.dart';
import 'package:todo_app/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();

  var _selectedValue;
  List<DropdownMenuItem<Object>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    List<Map<String, Object?>> categories =
        await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name'].toString()),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2200));
    if (_pickedDate != null) {
      _dateTime = _pickedDate;
      _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create todo'),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _todoTitleController,
                  decoration: InputDecoration(
                      labelText: 'Title', hintText: 'write todo title'),
                ),
                TextField(
                  controller: _todoDescriptionController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Write todo description'),
                ),
                TextField(
                  controller: _todoDateController,
                  decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Pick a date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      )),
                ),
                DropdownButtonFormField(
                    items: _categories,
                    value: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    }),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () async {
                    var todoObject = Todo();
                    todoObject.title = _todoTitleController.text;
                    todoObject.description = _todoDescriptionController.text;
                    todoObject.isFinished = 0;
                    todoObject.category = _selectedValue;
                    todoObject.todoDate = _todoDateController.text;

                    var _todoService = TodoService();
                    var result = await _todoService.saveTodo(todoObject);
                    debugPrint(result.toString());
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  color: Colors.blue,
                  child: Text(
                    'Save ',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )));
  }
}
