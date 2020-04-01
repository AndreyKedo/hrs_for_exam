import 'package:flutter/material.dart';

class DateFormField extends FormField<DateTime>{
  DateFormField({
    @required
    Function onChange,
    String hint,
    DateTime initValue,
    bool autoValidate = false,
    FormFieldSetter<DateTime> onSave,
    FormFieldValidator<DateTime> validator
  }) : assert(onChange != null) , super(
      initialValue : initValue,
      autovalidate : autoValidate,
      onSaved: onSave,
      validator: validator,
      builder: (FormFieldState<DateTime> state){
        return ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text(state.value != null ? '${state.value.day}.${state.value.month}.${state.value.year}' : hint),
          dense: true,
          onTap: () async {
            final DateTime value = await onChange();
            if(value != null)
              state.didChange(value);
          },
        );
      }
  );
}