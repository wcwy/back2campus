import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:back2campus/pages/account_page.dart';
import 'package:back2campus/pages/login_page.dart';
import 'package:back2campus/pages/splash_page.dart';
import 'package:back2campus/pages/routing_page.dart';

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
            onPrimary: Colors.white,
            primary: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/routing': (_) => const RoutingPage(),
      },
    );
    /*
    return MaterialApp(
      title: "NUS Map",
      home: RoutingScreen(),
    );
     */
  }
}