import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:back2campus/components/auth_state.dart';
import 'package:back2campus/utils/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  Future<void> _signUp() async {
    final response = await supabase.auth.signUp(emailController.text, passwordController.text);
    final error = response.error;

    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }else{
      Navigator.pushNamed(context, '/signin');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width*0.8,
              child: Column(
                children: <Widget>[
                   const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Sign Up",
                        //textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xff003d7c),
                          fontWeight: FontWeight.w500,
                          // fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 40,
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Color(0xFFB3B1B1),
                          ),
                          hintText: 'Your Email',
                          hintStyle: TextStyle(
                            color: Color(0xFFB3B1B1),
                            fontSize: 18,
                          ),
                          // Style when clicked
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Color(0xFFB3B1B1)),
                          ),
                          // Style when not clicked
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Colors.green),
                          ),
                          // Default style (same as above)
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,)
                          ),
                          // Style when error
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.black)
                          ),
                          // Style when error and clicked
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.yellowAccent)
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xff003d7c),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Color(0xFFB3B1B1),
                          ),
                          hintText: 'Your Password',
                          hintStyle: TextStyle(
                            color: Color(0xFFB3B1B1),
                            fontSize: 18,
                          ),
                          // Style when clicked
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Color(0xFFB3B1B1)),
                          ),
                          // Style when not clicked
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Colors.green),
                          ),
                          // Default style (same as above)
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,)
                          ),
                          // Style when error
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.black)
                          ),
                          // Style when error and clicked
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.yellowAccent)
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xff003d7c),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TextField(
                        controller: password2Controller,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                          labelStyle: TextStyle(
                            color: Color(0xFFB3B1B1),
                          ),
                          hintText: 'Your Password Again',
                          hintStyle: TextStyle(
                            color: Color(0xFFB3B1B1),
                            fontSize: 18,
                          ),
                          // Style when clicked
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Color(0xFFB3B1B1)),
                          ),
                          // Style when not clicked
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Colors.green),
                          ),
                          // Default style (same as above)
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,)
                          ),
                          // Style when error
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.black)
                          ),
                          // Style when error and clicked
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.yellowAccent)
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xff003d7c),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff003d7c),
                        onPrimary: Colors.white,
                        shadowColor: Colors.blueGrey,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(700, 40), //////// HERE
                      ),
                      onPressed: (){
                        _signUp();
                      },
                      child: Text('CREATE ACCOUNT'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff003d7c),
                        onPrimary: Colors.white,
                        shadowColor: Colors.blueGrey,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(700, 40), //////// HERE
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text('BACK TO HOME'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}