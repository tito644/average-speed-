// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.up,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height*0.22,
              right: 20,
              left: 20),
          backgroundColor: isError ? Colors.red : Colors.green,
          content: Text(message,textAlign: TextAlign.center)
      )
  );
}