import 'dart:async';

import 'package:hrs/datasource/local_datasource.dart';
import 'package:hrs/datasource/remote_datasource.dart';
import 'package:hrs/domain/entities/employee.dart';
import 'package:hrs/domain/entities/event.dart';
import 'package:hrs/domain/entities/position.dart';

class GeneralUseCase {
  GeneralUseCase({this.db, this.api});
  final LocalDatabase db;
  final RemoteAPI api;

  final StreamController<List<Employee>> _employeeController = StreamController<List<Employee>>.broadcast();
  final StreamController<List<Event>> _eventsController = StreamController<List<Event>>.broadcast();

  Stream<List<Employee>> get employees => _employeeController.stream;
  Stream<List<Event>> get events => _eventsController.stream;

  void getEmployees(){
    db.getEmployees().then((list){
      _employeeController.sink.add(list);
    });
  }

  void getEvents(){
    db.getEvents().then((list){
      _eventsController.sink.add(list);
    });
  }

  void addEvent(Event entity) async {
    await db.addEvent(entity);
    getEvents();
  }

  Future<List<Position>> positions() async {
    return await api.getPosition();
  }

  void addEmployee(Employee entity) async {
    await db.addEmployee(entity);
    getEmployees();
  }

  void removeEmployee(Employee entity){
    db.removeEmployee(entity);
    getEmployees();
  }

  Future<List<Event>> eventsForEmployee(int id){
    return db.getEventForEmployee(id);
  }

  void dispose(){
    _employeeController.close();
    _eventsController.close();
  }

}