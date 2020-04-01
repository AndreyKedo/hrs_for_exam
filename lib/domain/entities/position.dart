class Position{
  Position._(this.id, this.name, this.salary);
  final int id;
  final String name;
  final int salary;

  factory Position.fromMap(Map<String, dynamic> map){
    return Position._(map['id'], map['name'], map['salary']);
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'salary' : salary
    };
  }
}