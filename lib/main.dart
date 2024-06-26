import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/presentations/app_screens/base.dart';
import 'package:bibliogram_app/presentations/user_screens/login.dart';
import 'package:bibliogram_app/presentations/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String? token;
String? theme;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Get stored token data
  final userData = await UserToken.getStoreTokenData();
  final appSettings = await SettingsData.getSettingsData();
  token = userData["token"];
  theme = appSettings["selectedTheme"];
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: theme == 'Follow system theme'
          ? ThemeMode.system
          : theme == 'Dark'
              ? ThemeMode.dark
              : ThemeMode.light,
      initialRoute: token == null ? '/' : 'app',
      routes: {
        "/": (context) => const LoginPage(),
        "app": (context) => const AppBasePage(index: 0),
      },
    );
  }
}
