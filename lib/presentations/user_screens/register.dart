import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/models/user_model.dart';
import 'package:bibliogram_app/data/services/user.dart';
import 'package:bibliogram_app/presentations/user_screens/private_key.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  // Service variables
  UserApi userApi = UserApi();
  RegistrationResponse? registrationResponse;
  // State variables
  bool _loadingIndicator = false;

  switchLoadingIndicator() {
    setState(() {
      _loadingIndicator = !_loadingIndicator;
    });
  }

  Future<void> registrationDo(String fullname, String username) async {
    registrationResponse = await userApi.register({
      "fullname": fullname,
      "username": username,
    });
    switchLoadingIndicator();
    if (registrationResponse?.statusCode == statusCode["error"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["usernameTaken"]}',
        'error',
      );
    } else if (registrationResponse?.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else if (registrationResponse?.statusCode == statusCode["success"]) {
      Get.offAll(() =>
          PrivateKeyPage(privateKey: '${registrationResponse?.privateKey}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(index: 4),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Let\'s get you onboarded 🚀',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 340.0,
                    child: TextFormField(
                      controller: fullnameController,
                      textAlign: TextAlign.center,
                      decoration: userTextFieldDecoration('Fullname', context),
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return textFieldErrors["fullname"];
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
                      controller: usernameController,
                      textAlign: TextAlign.center,
                      decoration: userTextFieldDecoration('Username', context),
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return textFieldErrors["username"];
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
                        switchLoadingIndicator();
                        registrationDo(
                          fullnameController.text,
                          usernameController.text,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
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
                    child: _loadingIndicator
                        ? Container(
                            height: 30,
                            width: 32,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: loadingIndicator(),
                          )
                        : Icon(
                            Icons.arrow_forward_outlined,
                            size: 32.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 300.0,
                    child: Text(
                      'Note: Fullname will be used as the display name globally',
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
