import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrs/domain/entities/employee.dart';
import 'package:hrs/domain/entities/position.dart';
import 'package:hrs/widgets/custom_form_fields/date_form_field.dart';
import 'package:hrs/widgets/custom_form_fields/sex_selector_form_field.dart';
import 'package:hrs/widgets/screens/select_position_screen.dart';

class AddEmployeeScreen extends StatelessWidget {
  static final String route = '/add';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить сотрудника'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: _EmployeeForm(),
      ),
    );
  }
}

class _EmployeeForm extends StatefulWidget {
  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<_EmployeeForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final Employee _bundle = Employee();

  void _submitted(BuildContext context){
    if(_key.currentState.validate()){
      _key.currentState.save();
      Navigator.pop<Employee>(context, _bundle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Введите ФИО',
              prefixIcon: Icon(Icons.account_circle)
            ),
            validator: (value){
              return value.isNotEmpty ? null : 'Пустое поле';
            },
            onSaved: (value){
              _bundle.fio = value;
            },
          ),
          DateFormField(
            hint: 'Укажите дату рожения',
            onSave: (value){
              _bundle.dayOfBirth = value;
            },
            validator: (value){
              return value != null ? null : 'Пустое поле';
            },
            onChange: (){
              return showDatePicker(context: context, initialDate: DateTime(1999), firstDate: DateTime(1900), lastDate: DateTime(2000));
            },
          ),
          SexFormField(
            onSave: (value){
              _bundle.sex = value;
            },
          ),
          _PositionFormField(
            hint: 'Укажите вакансию',
            validator: (value){
              return value != null ? null : 'Пустое поле';
            },
            onChange: () {
              return Navigator.push<Position>(context, MaterialPageRoute<Position>(
                builder: (context){
                  return SelectPositionScreen();
                }
              ));
            },
            onSave: (value){
              _bundle.position = value;
            },
          ),
          RaisedButton(
            child: Text('Сохранить'),
            onPressed: (){
              _submitted(context);
            },
          )
        ],
      ),
    );
  }
}

class _PositionFormField extends FormField<Position>{
  _PositionFormField({
    @required
    Function onChange,
    String hint,
    Position initValue,
    bool autoValidate = false,
    FormFieldSetter<Position> onSave,
    FormFieldValidator<Position> validator
  }) : assert(onChange != null) , super(
    initialValue : initValue,
    autovalidate : autoValidate,
    onSaved: onSave,
    validator: validator,
    builder: (FormFieldState<Position> state){
      return ListTile(
        leading: Icon(Icons.description),
        title: Text(state.value != null ? state.value.name : hint),
        dense: true,
        onTap: () async {
          final value = await onChange();
          if(value != null)
            state.didChange(value);
        },
      );
    }
  );
}
