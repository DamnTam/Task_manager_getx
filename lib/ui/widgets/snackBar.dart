import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String msg, [bool moon=false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: moon?Colors.red:Colors.green,
    ),

  );
}
