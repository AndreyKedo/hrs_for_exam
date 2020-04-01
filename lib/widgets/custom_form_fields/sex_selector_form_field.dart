import 'package:flutter/material.dart';

class SexFormField extends FormField<bool>{
  SexFormField({
    bool initValue = false,
    bool autoValidate = false,
    FormFieldSetter<bool> onSave,
    FormFieldValidator<bool> validator
  }) : super(
      initialValue : initValue,
      autovalidate : autoValidate,
      onSaved: onSave,
      validator: validator,
      builder: (FormFieldState<bool> state){
        return Row(
          children: <Widget>[
            Padding(
              child: Icon(Icons.wc, color: Colors.grey,),
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            InputChip(label: Text('Мужчина'), selectedColor: Colors.indigo, selected: state.value, onPressed: (){
              state.didChange(!state.value);
            },),
            SizedBox(
              width: 10,
            ),
            InputChip(label: Text('Женщина'), selectedColor: Colors.indigo, selected: !state.value, onPressed: (){
              state.didChange(!state.value);
            },)
          ],
        );
      }
  );
}