// Automatic FlutterFlow imports
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// This plugin is using the popular internet_connection_checker_plus
// released under MIT license.
// Copyright 2019 Kristiyan Mitev and Spirit Navigator
// All credits go to them! find the plugin here: https://pub.dev/packages/internet_connection_checker_plus

Future<bool> ChecarConexaoInternet() async {
  // This returns true if the app is connected to the internet (determined by checking access to certain websites) and false if no internet connection can be established

  bool result = await InternetConnectionCheckerPlus().hasConnection;
  return result;
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
