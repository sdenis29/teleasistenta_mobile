import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.inputLabel,
      required this.icon,
      required this.obscure,
      required this.suggestions,
      required this.onChange,
      this.labelColor});
  final String inputLabel;
  final Icon icon;
  final bool obscure;
  final bool suggestions;
  final TextStyle? labelColor;
  Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
      child: TextFormField(
        decoration: InputDecoration(
          labelStyle: labelColor,
          border: const UnderlineInputBorder(),
          labelText: inputLabel,
          prefixIcon: icon,
        ),
        obscureText: obscure,
        enableSuggestions: suggestions,
        onChanged: onChange,
      ),
    );
  }
}
