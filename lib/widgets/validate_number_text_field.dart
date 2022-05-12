import 'package:flutter/material.dart';

class ValidateNumberTextField extends TextFormField {

  final String? error;
  final int? min;
  final int? max;

  ValidateNumberTextField({
    Key? key,
    this.error,
    this.min,
    this.max,
    TextEditingController? controller,
    Function(String)? onChanged,
    InputDecoration? decoration,
  }) : super(
    key: key,
    keyboardType: TextInputType.number,
    controller: controller,
    onChanged: onChanged,
    decoration: decoration,
  );


  @override
  FormFieldValidator<String>? get validator => (value) {
    if (value == null || value.isEmpty) {
      return error ?? 'Please enter some text';
    }

    if(min != null) {
      if(int.parse(value) < min!) {
        return 'Number must greater than $min';
      }
    }
    if(max != null) {
      if(int.parse(value) > max!) {
        return 'Number must less than $max';
      }
    }

    return null;
  }; // super.validator;

}


