import 'package:hrs/domain/entities/position.dart';

class Employee{

  Employee();

  Employee._init(this.id, {this.fio, this.dayOfBirth, this.sex, this.position});

  int id;
  String fio;
  DateTime dayOfBirth;
  bool sex;
  Position position;

  factory Employee.fromMap(Map<String, dynamic> map){
    return Employee._init(
        map['id'],
        fio: map['fio'],
        dayOfBirth: DateTime.fromMillisecondsSinceEpoch(map['day_of_birth']),
        sex: map['sex'] == 1 ? true : false,
        position: Position.fromMap({
          'id' : map['id_position'],
          'name' : map['name'],
          'salary' : map['salary']
        })
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'fio' : fio,
      'day_of_birth' : dayOfBirth.millisecondsSinceEpoch,
      'sex' : sex ? 1 : 0,
    };
  }

}