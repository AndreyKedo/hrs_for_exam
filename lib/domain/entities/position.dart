class Position{
  Position._(this._id, this.name, this.salary);
  final int _id;
  final String name;
  final int salary;

  factory Position.fromMap(Map<String, dynamic> map){
    return Position._(map['id'], map['name'], map['salary']);
  }

  Map<String, dynamic> toMap(Position value){
    return {
      'name' : value.name,
      'salary' : value.salary
    };
  }
}