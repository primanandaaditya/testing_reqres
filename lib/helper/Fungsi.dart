import 'package:flutter/material.dart';

class Fungsi{
  static showSnack(BuildContext context, String konten, String label, int durasiDetik ){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:  Text(konten),
      duration: Duration(seconds: durasiDetik ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      action: SnackBarAction(
        label: label,
        onPressed: () {

        },
      ),
    ));
  }
}