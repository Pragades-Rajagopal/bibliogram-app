import 'package:bibliogram_app/presentations/user_screens/login.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PrivateKeyPage extends StatefulWidget {
  final String privateKey;
  const PrivateKeyPage({
    super.key,
    required this.privateKey,
  });

  @override
  State<PrivateKeyPage> createState() => _PrivateKeyPageState();
}

class _PrivateKeyPageState extends State<PrivateKeyPage> {
  final privateKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      privateKeyController.text = widget.privateKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: appBar(index: 4),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '''Eureka!\nYou are registered successfully
                    \nThis is your Private key''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  SizedBox(
                    width: 340.0,
                    child: TextField(
                      controller: privateKeyController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 244, 123, 3),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: privateKeyController.text),
                      );
                      Get.offAll(() => const LoginPage());
                    },
                    child: const Text(
                      'Copy key and login',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 300.0,
                    child: Text(
                      'Warning: Please copy this Private Key somewhere, which will be used to login on other devices',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
