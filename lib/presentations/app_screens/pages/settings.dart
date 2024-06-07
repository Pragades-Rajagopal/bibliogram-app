import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/user_model.dart';
import 'package:bibliogram_app/data/services/user.dart';
import 'package:bibliogram_app/presentations/user_screens/login.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme = 'Follow system theme';
  String username = '';
  String name = '';
  String _token = '';
  String _userId = '';
  List<String> themes = [
    'Follow system theme',
    'Light',
    'Dark',
  ];
  // Services
  UserApi userApi = UserApi();

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    final appSettings = await SettingsData.getSettingsData();
    final userData = await UserToken.getStoreTokenData();
    setState(() {
      username = userData["username"];
      name = userData["name"];
      _userId = userData["id"];
      _token = userData["token"];
      selectedTheme = appSettings["selectedTheme"];
    });
  }

  Future<void> logoutDo() async {
    LogoutResponse? response = await userApi.logout(
      {
        "username": username,
      },
      _userId,
      _token,
    );
    if (response.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else if (response.statusCode == statusCode["success"]) {
      showSnackBar(
        '${alertDialog["commonSuccess"]}',
        '${alertDialog["logoutSuccess"]}',
        'success',
      );
      await UserToken.purgeTokenData();
      await SettingsData.purgeSettingsData();
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Settings', index: 4),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Logged in as ',
                    ),
                    TextSpan(
                      text: name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ( $username )',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                'App Theme',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 280.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 8, 4),
                  child: DropdownButtonFormField(
                    elevation: 2,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    ),
                    value: selectedTheme,
                    onChanged: (String? newTheme) async {
                      await SettingsData.storeSettingsData(newTheme!);
                    },
                    items: themes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    icon: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                'Close the app and reopen to apply the selected theme!',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(
                height: 22.0,
              ),
              TextButton(
                onPressed: () {
                  _showBottomSheet(context, 'logout');
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.fromLTRB(0, 0, 18, 0),
                  ),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    // fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Text(
                'Hope you had noted down the Private key during the initial login!',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(
                height: 22.0,
              ),
              TextButton(
                onPressed: () {
                  _showBottomSheet(context, 'deactivate');
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.fromLTRB(0, 0, 18, 0),
                  ),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                ),
                child: const Text(
                  'Deactivate',
                  style: TextStyle(
                    color: Colors.red,
                    // fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Text(
                '''Deactivating the account means ...
  - All your notes & comments will be lost
  - You cannot reactivate later and this action is irreversible
                ''',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String actionType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0.0,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 220,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  actionType == 'logout'
                      ? 'Note: Make sure you have the Private key to log back in'
                      : 'Are you sure, you want to deactivate and leave this lovely community?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () async {
                    actionType == 'logout' ? logoutDo() : print('deactivate');
                  },
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  ),
                  child: Text(
                    actionType == 'logout'
                        ? 'Logout Now'
                        : 'Proceed to Deactivate',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    // Close the bottom sheet
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 24.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 14.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
