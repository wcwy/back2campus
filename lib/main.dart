import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';

import 'package:back2campus/pages/splash_page.dart';
import 'package:back2campus/pages/routing_page.dart';
import 'package:back2campus/pages/signup_page.dart';
import 'package:back2campus/pages/signin_page.dart';
import 'package:back2campus/pages/layout_page.dart';
import 'package:back2campus/pages/shared_page.dart';
import 'package:back2campus/pages/writeroute_page.dart';

Future<void> main() async {
  // Supabase Initialization
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rlemxzljabcaylnhetcv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsZW14emxqYWJjYXlsbmhldGN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTM4ODQ5NjIsImV4cCI6MTk2OTQ2MDk2Mn0.ENIdAS3--1XgqT3Ufizp8bwpQSml0xSdUr8M8IR6nVo',
  );
  // End of Supabase Initialization

  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Back2Campus',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xff003d7c),
            onPrimary: Colors.white,
            shadowColor: Colors.blueGrey,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/signup': (_) => const SignupPage(),
        '/signin': (_) => const SigninPage(),
        '/routing': (_) => const RoutingPage(),
        '/layout': (_) => const LayoutPage(),
        '/shared': (_) => const SharedPage(),
        '/writeroute': (_) => const WriteroutePage(),
      },
    );
  }
}