import 'package:hrs/domain/entities/position.dart';

class Employee{

  Employee._(this._id, {this.fio, this.dayOfBirth, this.sex, this.position});

  final int _id;
  final String fio;
  final DateTime dayOfBirth;
  final bool sex;
  final Position position;

  factory Employee.fromMap(Map<String, dynamic> map){
    return Employee._(
        map['id'],
        fio: map['fio'],
        dayOfBirth: DateTime.fromMillisecondsSinceEpoch(map['day_of_birth']),
        sex: map['sex'],
        position: map['position']
    );
  }
}