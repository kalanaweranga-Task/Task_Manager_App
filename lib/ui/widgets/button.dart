import 'package:flutter/material.dart';
import 'package:task_management_app/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        alignment: Alignment.center,

        width: 90,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          
          style: const TextStyle(
            // center the text on the button

            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),


      )
    );
  }
}