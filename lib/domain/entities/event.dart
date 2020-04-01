import 'package:hrs/domain/entities/employee.dart';

class  Event{

  Event({this.type, this.date, this.entity});

  Event._({this.type, this.date, this.entity});

  String type;
  DateTime date;
  Employee entity;

  bool build() => type != null && date != null && entity != null;

  factory Event.fromMap(Map<String, dynamic> map){
    return Event._(
      type: map['type'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      entity: Employee.fromMap({
        'id' : map['employee.id'],
        'fio' : map['fio'],
        'day_of_birth' : map['day_of_birth'],
        'sex' : map['sex'] == 1 ? true : false
      })
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'type' : type,
      'date' : date.millisecondsSinceEpoch,
      'id_employee' : entity.id
    };
  }
}