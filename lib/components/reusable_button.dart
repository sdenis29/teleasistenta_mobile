import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton(
      {super.key,
      required this.color,
      required this.onPress,
      required this.buttonChild,
      this.width_factor,
      this.height_factor});

  final Color color;
  final VoidCallback onPress;
  final Widget buttonChild;
  final double? width_factor;
  final double? height_factor;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: color,
        elevation: 10,
        // padding: EdgeInsets.symmetric(
        // horizontal: width * width_factor!,
        // vertical: height * height_factor!),
      ),
      child: buttonChild,
    );
  }
}
