import 'package:sqflite/sqflite.dart';

class LocalDatabase{
  Database db;

  void init(String name) async {
    if(db != null)
      return;
    db = await openDatabase(name, version: 1, onConfigure: (db) async {
      await db.execute('PRAGMA foreing_keys = ON');
    }, onCreate: (db, version) async{
      await db.execute('''CREATE TABLE position (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          salary TEXT NOT NULL
          )''');
      await db.execute('''CREATE TABLR employee (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          fio TEXT NOT NULL,
          day_of_birth TEXT NOT NULL,
          sex INTEGER NOT NUL
          id_position INTEGER NOT NULL,
          FOREIGN KEY(id_position) REFERENCES position(id)
      )''');
      await db.execute('''CREATE TABLE event (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          type TEXT NOT NULL,
          date INTEGER NOT NULL,
          id_employee INTEGER NOT NULL,
          FOREIGN KEY(id_employee) REFERENCES employee(id)
      )''');
    });
  }




  void dispose(){
    db.close();
  }
}