import 'package:flutter/services.dart';

Future<Map<String, String>> accessENV({String assetFileName = '.env'}) async {
  final variables = await rootBundle.loadString(assetFileName);
  Map<String, String> environment = {};
  for (String variable in variables.split('\n')) {
    variable = variable.trim();
    if (variable.contains('=') && !variable.startsWith(RegExp(r'=|#'))) {
      List<String> contents = variable.split('=');
      environment[contents[0]] = contents.sublist(1).join('=');
    }
  }
  return environment;
}
