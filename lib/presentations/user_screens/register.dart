import 'package:bibliogram_app/presentations/user_screens/private_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
                const Text('Registration Page'),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  width: 340.0,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Fullname',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  width: 340.0,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const PrivateKeyPage());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.green,
                    minimumSize: const Size(60, 60),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_outlined,
                    size: 32.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
