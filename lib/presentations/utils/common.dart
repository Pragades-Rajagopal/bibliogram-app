import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar appBar = AppBar(
  automaticallyImplyLeading: false,
  backgroundColor: const Color.fromARGB(121, 0, 150, 135),
  title: const Text(
    'Bibliogram',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),
);

errorSnackBar(String title, String message) {
  return Get.snackbar(
    title,
    message,
    icon: const Icon(
      Icons.cancel_outlined,
      color: Colors.red,
    ),
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 60),
    backgroundColor: const Color(0xFFFFDAD7),
    colorText: Colors.black,
    maxWidth: 350.0,
    duration: const Duration(seconds: 2),
  );
}

userTextFieldDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color.fromRGBO(134, 134, 134, 1),
      fontSize: 20.0,
    ),
    errorStyle: const TextStyle(
      fontSize: 14.0,
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
  );
}
