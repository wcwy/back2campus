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
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _text = '';
  bool _submitted = false;

  // Email format checker. Return value is the error message.
  // Return null if email format is correct.
  String? get _emailErrorText {
    // Email validation based on HTML5 spec
    // Reference: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#e-mail-state-%28type=email%29
    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(emailController.text)){
      return 'Invalid email format';
    }

    // return null if the text is valid
    return null;
  }

  // Username format checker. Return value is the error message.
  // Return null if username format is correct.
  String? get _usernameErrorText {
    // Check for minimum length of 3
    if (usernameController.value.text.length < 3) {
      return 'Minimum 3 characters';
    }
    // return null if the text is valid
    return null;
  }

  // Password format checker. Return value is the error message.
  // Return null if password format is correct.
  String? get _passwordErrorText {
    // Check for minimum length of 10
    if (passwordController.value.text.length < 10) {
      return 'Minimum 10 characters';
    }
    // Check for minimum one upper and one lower case letter
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z]).{10,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(passwordController.text)){
      return 'At least 1 upper and 1 lower case character';
    }

    // Check for minimum one number and one symbol
    pattern = r'^(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,}$';
    regExp = new RegExp(pattern);
    if (!regExp.hasMatch(passwordController.text)){
      return 'At least 1 number and 1 symbol (!@#\\\$&*~)';
    }

    // return null if the text is valid
    return null;
  }

  Future<void> _signUp() async {
    setState(() => _submitted = true);
    if (_emailErrorText == null && _usernameErrorText == null && _passwordErrorText == null) {
      var response = await supabase.auth.signUp(emailController.text, passwordController.text);
      var error = response.error;

      if (error != null) {
        context.showErrorSnackBar(message: error.message);
      }else{
        var user_id = supabase.auth.currentUser!.id;
        var user_name = usernameController.text;

        // Insert user profile into database (profiles table)
        var res = await supabase
            .from('profiles')
            .insert([
          {
            'id': user_id,
            'updated_at': DateTime.now().toIso8601String(),
            'username': user_name,
            'avatar_url': "default.jpg",
          }
        ]).execute();

        if (res.hasError) {
          context.showErrorSnackBar(message: res.error!.message);
        } else {
          // Sign in user automatically into the app
          response = await supabase.auth.signIn(email: emailController.text, password: passwordController.text);
          back2campususer = response.data?.user;
          error = response.error;
          setState(() {
            profilepicurl = supabase.storage.from('avatars').getPublicUrl("default.jpg").data!; // Set profile pic url on sign in
          });
          if (error != null) {
            context.showErrorSnackBar(message: error.message);
          }else{
            context.showSnackBar(message: 'Welcome $user_name!');
            Navigator.pushNamed(context, '/routing');
          }
        }
      }
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
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            color: Color(0xFFB3B1B1),
                          ),
                          hintText: 'A valid email',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB3B1B1),
                            fontSize: 18,
                          ),
                          errorText: _submitted ? _emailErrorText : null,
                          // Style when clicked
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Color(0xFFB3B1B1)),
                          ),
                          // Style when not clicked
                          enabledBorder: const UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Colors.green),
                          ),
                          // Default style (same as above)
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,)
                          ),
                          // Style when error
                          errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),
                          // Style when error and clicked
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.redAccent)
                          ),
                        ),
                        onChanged: (text) => setState(() => _text), // This line is needed to update the widget on every change
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
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(
                            color: Color(0xFFB3B1B1),
                          ),
                          hintText: 'A unique username',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB3B1B1),
                            fontSize: 11,
                          ),
                          errorText: _submitted ? _usernameErrorText : null,
                          // Style when clicked
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Color(0xFFB3B1B1)),
                          ),
                          // Style when not clicked
                          enabledBorder: const UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Colors.green),
                          ),
                          // Default style (same as above)
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,)
                          ),
                          // Style when error
                          errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),
                          // Style when error and clicked
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.redAccent)
                          ),
                        ),
                        onChanged: (text) => setState(() => _text), // This line is needed to update the widget on every change
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
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Color(0xFFB3B1B1),
                          ),
                          hintText: 'Min. 1 upper case, 1 lower case, 1 number and 1 symbol',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB3B1B1),
                            fontSize: 11,
                          ),
                          errorText: _submitted ? _passwordErrorText : null,
                          // Style when clicked
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Color(0xFFB3B1B1)),
                          ),
                          // Style when not clicked
                          enabledBorder: const UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: Colors.green),
                          ),
                          // Default style (same as above)
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,)
                          ),
                          // Style when error
                          errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.red)
                          ),
                          // Style when error and clicked
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.redAccent)
                          ),
                        ),
                        onChanged: (text) => setState(() => _text), // This line is needed to update the widget on every change
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