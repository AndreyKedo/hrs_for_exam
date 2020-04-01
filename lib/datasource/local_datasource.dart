import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hrs/domain/entities/employee.dart';
import 'package:hrs/domain/entities/event.dart';
import 'package:hrs/domain/entities/position.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase{
  Database db;

  LocalDatabase(String name){
    _init(name);
  }

  @required
  _init(String name) async {
    if(db != null)
      return;
    db = await openDatabase(name, version: 1, onConfigure: (db) async {
      await db.execute('PRAGMA foreing_keys = ON');
    }, onCreate: (db, version) async{
      await db.execute('''CREATE TABLE position (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          salary INTEGER NOT NULL
          )''');
      await db.execute('''CREATE TABLE employee (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          fio TEXT NOT NULL,
          day_of_birth INTEGER NOT NULL,
          sex INTEGER NOT NULL,
          remove INTEGER DEFAULT 0,
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
    GetIt.I.signalReady(this);
  }

  Future setPosition(List<Position> value) async {
    try{
      var count  = await db.query('position', columns: ['COUNT(*)']);
      log(count.toString());
    } on DatabaseException catch(e){
      log('Error:', error: e);
      return Future.error(e);
    }
  }

  Future addEmployee(Employee entity) async {
    try{
      return await db.transaction((thx) async {
        await thx.insert('position', entity.position.toMap());
        final List<Map<String, dynamic>> position = await thx.query('position');
        await thx.insert('employee', entity.toMap()..['id_position'] = position.last['id']);
        final List<Map<String, dynamic>> lastInsert = await thx.query('employee');
        await thx.insert('event', {
          'type' : 'Устроился на работу',
          'date' : DateTime.now().millisecondsSinceEpoch,
          'id_employee' : lastInsert.last['id']
        });
      });
    } on DatabaseException catch(e){
      log('Error:', error: e);
      return Future.error(e);
    }
  }

  Future removeEmployee(Employee entity) async {
    try{
      db.transaction((thx) async {
        await thx.update('employee', { 'remove' : 1 }, where: 'id = ?', whereArgs: [entity.id]);
        await thx.insert('event', {
          'type' : 'Уволилен',
          'date' : DateTime.now().millisecondsSinceEpoch,
          'id_employee' : entity.id
        });
      });
    } on DatabaseException catch(e){
      log('Error:', error: e);
      return Future.error(e);
    }
  }

  Future<List<Employee>> getEmployees() async {
    try{
      final List<Map<String, dynamic>> result = await db.rawQuery('''SELECT
          employee.id, employee.fio, employee.day_of_birth, employee.sex,
          employee.id_position, position.name, position.salary 
          FROM employee LEFT JOIN position on employee.id_position = position.id WHERE employee.remove = ?''', [0]);
      return result.map<Employee>((map) => Employee.fromMap(map)).toList();
    } on DatabaseException catch(e){
      log('Error:', error: e);
      return Future.error(e);
    }
  }

  Future addEvent(Event entity) async {
    try{
      await db.insert('event', entity.toMap());
    } on DatabaseException catch(e){
      log('Error:', error: e);
      return Future.error(e);
    }
  }

  Future<List<Event>> getEventForEmployee(int id) async {
    try{
      final List<Map<String, dynamic>> result = await db.rawQuery('''SELECT event.type, event.date, employee.id, 
      employee.fio, employee.day_of_birth, employee.sex,
      position.name, position.salary
      FROM event LEFT JOIN employee on event.id_employee = employee.id 
      LEFT JOIN position on employee.id_position = position.id WHERE employee.id = ?''', [id]);
      return result.map<Event>((map) => Event.fromMap(map)).toList();
    } on  DatabaseException catch(e){
      log('Error:', error: e);
      return Future.error(e);
    }
  }

  Future<List<Event>> getEvents() async {
    try{
      final List<Map<String, dynamic>> result = await db.rawQuery('''SELECT event.type, event.date, employee.id, 
      employee.fio, employee.day_of_birth, employee.sex,
      position.name, position.salary
      FROM event LEFT JOIN employee on event.id_employee = employee.id 
      LEFT JOIN position on employee.id_position = position.id''');
      return result.map<Event>((map) => Event.fromMap(map)).toList();
    } on DatabaseException catch(e){
      log('Error:', error: e);
      return Future.error(e);
    }
  }

  @required
  void dispose(){
    db.close();
  }
}