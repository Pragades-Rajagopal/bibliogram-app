import 'package:bibliogram_app/presentations/user_screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalAppPage extends StatefulWidget {
  const GlobalAppPage({super.key});

  @override
  State<GlobalAppPage> createState() => _GlobalAppPageState();
}

class _GlobalAppPageState extends State<GlobalAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Logout'),
          onPressed: () {
            Get.to(() => const LoginPage());
          },
        ),
      ),
    );
  }
}
