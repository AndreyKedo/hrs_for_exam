import 'package:hrs/domain/entities/employee.dart';

class Event{
  Event._({this.type, this.date, this.entity});

  final String type;
  final DateTime date;
  final Employee entity;

  factory Event.fromMap(Map<String, dynamic> map){
    return Event._(
      type: map['type'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      entity: map['employee']
    );
  }
}