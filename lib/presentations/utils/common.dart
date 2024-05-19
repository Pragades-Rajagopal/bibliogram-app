import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

AppBar appBar = AppBar(
  automaticallyImplyLeading: false,
  title: const Text(
    'Bibliogram',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),
  centerTitle: true,
);

showSnackBar(String title, String message, String type) {
  return Get.snackbar(
    title,
    message,
    icon: type == 'error'
        ? const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
          )
        : const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ),
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 60),
    backgroundColor:
        type == 'error' ? const Color(0xFFFFDAD7) : const Color(0xFFEEFFEE),
    colorText: Colors.black,
    maxWidth: 350.0,
    duration: const Duration(seconds: 2),
  );
}

userTextFieldDecoration(String hint, BuildContext context) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 20.0,
    ),
    errorStyle: const TextStyle(
      fontSize: 14.0,
      color: Colors.red,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.tertiary,
      ),
    ),
  );
}

loadingIndicator() {
  return const LoadingIndicator(
    indicatorType: Indicator.lineSpinFadeLoader,
    colors: [
      Colors.white,
      Colors.white70,
      Colors.white60,
      Colors.white54,
      Colors.white38,
      Colors.white30,
      Colors.white24,
      Colors.white10,
    ],
  );
}

const bottomNavBar = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.data_exploration_outlined),
    activeIcon: Icon(Icons.data_exploration_sharp),
    label: 'Global',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.book_outlined),
    activeIcon: Icon(Icons.book_rounded),
    label: 'Books',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.sticky_note_2_outlined),
    activeIcon: Icon(Icons.sticky_note_2_sharp),
    label: 'My Activities',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.search),
    activeIcon: Icon(Icons.search_rounded),
    label: 'Search',
  ),
];
