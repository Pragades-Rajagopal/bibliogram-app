import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
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
  UserToken? userToken;
  // State variables
  bool _loadingIndicator = false;

  void switchLoadingIndicator() {
    setState(() {
      _loadingIndicator = !_loadingIndicator;
    });
  }

  Future<void> loginDo(String username, String privateKey) async {
    loginResponse = await userApi.login({
      "username": username,
      "privateKey": privateKey,
    });
    switchLoadingIndicator();
    if (loginResponse?.statusCode == statusCode["notFound"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["notRegistered"]}',
        'error',
      );
    } else if (loginResponse?.statusCode == statusCode["unauthorized"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["invalidAuth"]}',
        'error',
      );
    } else if (loginResponse?.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else if (loginResponse?.statusCode == statusCode["success"]) {
      // Parsing token from the API response
      userToken = UserToken.parseToken(loginResponse?.token);
      await UserToken.storeTokenData(userToken!, loginResponse?.token);
      Get.offAll(() => const AppBasePage(index: 0));
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
                  const SizedBox(
                    width: 340,
                    child: Text(
                      'Login and start taking notes from the books you like the most\n❤️',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
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
                      decoration:
                          userTextFieldDecoration('Private Key', context),
                      cursorColor: Theme.of(context).colorScheme.secondary,
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
                        switchLoadingIndicator();
                        loginDo(
                          usernameController.text,
                          privateKeyController.text,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
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
