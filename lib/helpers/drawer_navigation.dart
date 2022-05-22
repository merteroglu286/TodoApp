import 'package:flutter/material.dart';
import 'package:todo_app/screen/todos_category.dart';
import 'package:todo_app/services/category_service.dart';

import '../screen/categories_screen.dart';
import '../screen/home_screen.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = [];

  CategoryService _categoryService = CategoryService();
  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();
    if (categories is List) {
      categories.forEach((category) {
        setState(() {
          _categoryList.add(InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TodosByCategory(
                          category: category['name'].toString(),
                        ))),
            child: ListTile(
              title: Text(category['name']),
            ),
          ));
        });
      });
    } else {
      setState(() {
        _categoryList.add(ListTile(
          title: Text(categories['name']),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.woolha.com/media/2020/03/eevee.png'),
              ),
              accountName: Text('test'),
              accountEmail: Text('admin.admin'),
              decoration: BoxDecoration(color: Colors.amber),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
                leading: Icon(Icons.view_list),
                title: Text('Categories'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoriesScreen(),
                    ))),
            Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
