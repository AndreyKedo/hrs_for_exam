import 'package:flutter/material.dart';
import 'package:hrs/domain/enums/event_type.dart';
import 'package:hrs/widgets/custom_form_fields/date_form_field.dart';

class AddEventDialog extends StatefulWidget {
  AddEventDialog({this.nameEmployee, this.types}) : assert(nameEmployee != null);
  final Map<String, dynamic> _bundle = {};
  final Map<EventType, String> types;
  final String nameEmployee;
  @override
  State<StatefulWidget> createState() => AddEventDialogState();
}

class AddEventDialogState extends State<AddEventDialog>{
  final GlobalKey<FormState> _key = GlobalKey();
  MapEntry<EventType, String> _pair;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.nameEmployee),
      content: Container(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<MapEntry<EventType, String>>(
                items: widget.types.entries.map<DropdownMenuItem<MapEntry<EventType, String>>>((pair){
                  return DropdownMenuItem<MapEntry<EventType, String>>(value: pair,child: Text(pair.value));
                }).toList(),
                onChanged: (value){
                  setState(() {
                    _pair = value;
                  });
                },
                isDense: true,
                hint: Text(_pair != null ? _pair.value : 'Укажите тип события'),
                validator: (value){
                  return value != null ? null : 'Пустое поле';
                },
                onSaved: (value){
                  widget._bundle['t'] = value.value;
                },
              ),
              DateFormField(
                initValue: DateTime.now(),
                onChange: (){
                  return showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1999), lastDate: DateTime(2047));
                },
                onSave: (value){
                  widget._bundle['d'] = value;
                },
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Navigator.pop(context, null);
        }, child: Text('Отменить')),
        FlatButton(onPressed: (){
          if(_key.currentState.validate()){
            _key.currentState.save();
            Navigator.pop<Map<String, dynamic>>(context, widget._bundle);
          }
        }, child: Text('Зафиксировать')),
      ],
    );
  }
}


