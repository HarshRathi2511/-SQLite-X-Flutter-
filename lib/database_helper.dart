import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class DataBaseHelper {
   //created a singleton class that can have only one object(instance) at a time  

  static final _dbName = 'myDatabase.db';
  static final _dbVersion =1;
  static final _tableName = 'myTable';
  static final columnId ='_id';
  static final columnName ='name' ;

  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance =DataBaseHelper._privateConstructor(); 
  //once initiated wont be changed
  
  //add a function that init the database 
  
  static Database? _database;

  Future<Database> get database async {   //return the  <DataBase> which we created 
    //if database is existing then return the database 
    if(_database!=null){
        return _database!; 
    }
    //otherwise initiate and then return the database 
    _database= await _initiateDatabase();
    return _database!;

  } 
  
   _initiateDatabase() async {
    //from the path provider -> to get the directory where the application is located 
    Directory directory = await getApplicationDocumentsDirectory();
    //join ->from the path package 
    String path = join(directory.path,_dbName); //we get the path where the data us stored 

    return await openDatabase(path,version: _dbVersion ,onCreate: _onCreate);
    //'FutureOr<void> Function(Database, int)?'.dart
    //give the database a version ->keep track of the version
  }

   //Function(Database, int)?
  Future _onCreate (Database db, int version) async {
    //create a new table 
    await db.execute(
      '''
       CREATE TABLE $_tableName(
         $columnId INTEGER PRIMARY KEY,
         $columnName TEXT NOT NULL )
      '''
    ); //This is a helper to query a table and return the items found
   //table name -> then specify the names of the column 
   //   id | column
   //   ...|...
  }

  //commands -> insert,update,delete,query 
  //query will be a list of maps returned from the table 

  //insert function  
  Future<int> insert( Map<String,dynamic> row) async {
    Database db = await instance.database; //get the database from the present instance 
    
    return await db.insert(_tableName, row); //row will be {'id':..., 'name' : 'Harsh'}
  } //it returns the primary key automatically as a unique integer of the inserted row \

  //query functiom
  Future<List<Map<String,dynamic>>> queryAll () async {
    Database db = await instance.database; //present instance of the database 
    return await db.query(_tableName);
  }

  //update function 
  Future<int> update (Map<String,dynamic> row ) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(_tableName, row ,where: '$columnId = ?' ,whereArgs: [id]);
  //Convenience method for updating rows in the database. Returns the number of changes made
  // Update [table] with [values], a map from column names to new column values.
  // null is a valid value that will be translated to NULL.

  //eg
  //int count = await db.update(tableTodo, todo.toMap(),
  //  where: '$columnId = ? $columnName = ?', whereArgs: [todo.id]);
  //you can pass multiple arguments 
  }

  //{'_id': 1, 'name': 'Harsh'}
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(_tableName,where: '$columnId =?',whereArgs: [id]);
  }
}
