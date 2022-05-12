import 'package:flutter/material.dart';

class ValidateTextField extends TextFormField {

  final String? error;


  ValidateTextField({
    Key? key,
    this.error,
    TextEditingController? controller,
    Function(String)? onChanged,
    InputDecoration? decoration,
  }) : super(
      key: key,
      controller: controller,
      onChanged: onChanged,
      decoration: decoration
  );


    @override
  FormFieldValidator<String>? get validator => (value) {
      if (value == null || value.isEmpty) {
        return error ?? 'Please enter some text';
      }
      return null;
    }; // super.validator;

}


