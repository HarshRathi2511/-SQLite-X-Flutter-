import 'package:flutter/material.dart';
import 'package:test_packages/database_helper.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqflite Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                int i = await DataBaseHelper.instance.insert({
                  //pass the map
                  // 'name' :'Harsh',
                  DataBaseHelper.columnName: 'Harsh',
                  //the key would be automatically added as it is a primary key
                });
                print('Inserted id is $i');
              },
              child: Text('insert'),
            ),
            TextButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                      await DataBaseHelper.instance.queryAll();
                  print(queryRows);
                },
                child: Text('query')),
            TextButton(onPressed: () async {
              int rowsAffected = await DataBaseHelper.instance.update({
                DataBaseHelper.columnName : 'Mona',
                DataBaseHelper.columnId :'12' ,
              });
              print(rowsAffected);
            }, child: Text('update')),
            TextButton(onPressed: () {}, child: Text('delete')),
          ],
        ),
      ),
    );
  }
}
