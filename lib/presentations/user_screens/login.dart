import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/models/user_model.dart';
import 'package:bibliogram_app/data/services/user.dart';
import 'package:bibliogram_app/presentations/app_screens/base.dart';
import 'package:bibliogram_app/presentations/user_screens/register.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final privateKeyController = TextEditingController();
  // Service variables
  UserApi userApi = UserApi();
  LoginResponse? loginResponse;

  Future<void> loginDo(String username, String privateKey) async {
    loginResponse = await userApi.login({
      "username": username,
      "privateKey": privateKey,
    });
    if (loginResponse?.statusCode == statusCode["notFound"]) {
      errorSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["notRegistered"]}',
      );
    } else if (loginResponse?.statusCode == statusCode["unauthorized"]) {
      errorSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["invalidAuth"]}',
      );
    } else if (loginResponse?.statusCode == statusCode["serverError"]) {
      errorSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
      );
    } else if (loginResponse?.statusCode == statusCode["success"]) {
      Get.offAll(() => const AppBasePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Text('Login Page'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 340.0,
                    child: TextFormField(
                      controller: usernameController,
                      textAlign: TextAlign.center,
                      decoration: userTextFieldDecoration('Username'),
                      cursorColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return textFieldErrors["username"];
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 340.0,
                    child: TextFormField(
                      controller: privateKeyController,
                      textAlign: TextAlign.center,
                      decoration: userTextFieldDecoration('Private Key'),
                      cursorColor: Colors.white,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return textFieldErrors["privateKey"];
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginDo(
                          usernameController.text,
                          privateKeyController.text,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.blue,
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
                  TextButton(
                    onPressed: () {
                      Get.to(() => const RegistrationPage());
                    },
                    child: const Text(
                      'Register',
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
      ),
    );
  }
}
