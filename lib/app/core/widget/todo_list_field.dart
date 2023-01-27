import 'package:flutter/material.dart';
import 'package:todo_list_app/app/core/ui/theme_extensions.dart';
import 'package:todo_list_app/app/core/ui/to_do_list_icons.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  TodoListField(
      {Key? key,
      required this.label,
      this.suffixIconButton,
      this.obscureText = false,
      this.controller,
      this.validator,
      this.focusNode})
      : assert(obscureText == true ? suffixIconButton == null : true,
            'obscureText não pode ser enviado juntamente com um suffixIconButton'),
        obscureTextVN = ValueNotifier(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscureTextVN,
      builder: (_, obscureTextValue, child) {
        return TextFormField(
          controller: controller,
          validator: validator,
          focusNode: focusNode,
          cursorColor: context.primaryColor,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: 15, color: Colors.black),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: context.primaryColor),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: context.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.red),
              ),
              isDense: true,
              suffixIcon: suffixIconButton ??
                  (obscureText == true
                      ? IconButton(
                          color: context.primaryColor,
                          onPressed: () {
                            obscureTextVN.value = !obscureTextVN.value;
                          },
                          icon: Icon(
                            obscureTextValue
                                ? ToDoListIcons.eye
                                : ToDoListIcons.eye_slash,
                            size: 15,
                          ),
                        )
                      : null)),
          obscureText: obscureTextValue,
        );
      },
    );
  }
}
