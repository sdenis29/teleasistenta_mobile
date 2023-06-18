import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    super.key,
    required this.color,
    required this.onPress,
    required this.buttonChild,
  });

  final Color color;
  final VoidCallback onPress;
  final Widget buttonChild;

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
      ),
      child: buttonChild,
    );
  }
}
