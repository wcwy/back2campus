import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
var back2campususer = null;
var chosenSource = "COM1";
var chosenDestination = "COM2";
var profilepicurl = "https://rlemxzljabcaylnhetcv.supabase.co/storage/v1/object/public/avatars/default.jpg";

var routeselected = "c39b7c37-6d1c-4598-9420-f006955d6f65"; // storing route_id used for viewroute_page

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}