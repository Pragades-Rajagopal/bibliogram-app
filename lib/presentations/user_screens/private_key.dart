import 'package:bibliogram_app/presentations/user_screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PrivateKeyPage extends StatefulWidget {
  const PrivateKeyPage({super.key});

  @override
  State<PrivateKeyPage> createState() => _PrivateKeyPageState();
}

class _PrivateKeyPageState extends State<PrivateKeyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Eureka!\nYou are registered successfully',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  width: 340.0,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'SomeKey',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const LoginPage());
                  },
                  child: const Text(
                    'Copy key and exit',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
