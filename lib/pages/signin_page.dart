import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:back2campus/utils/constants.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _signIn() async {
    final response = await supabase.auth.signIn(email: emailController.text, password: passwordController.text);

    back2campususer = response.data?.user;
    final error = response.error;

    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }else{
      // Check if the profile table exists for this user (For backwards compatibility of users registered before profile was implemented)
      var res = await supabase
          .from('profiles')
          .select('id, username')
          .eq('id', supabase.auth.currentUser!.id)
          .execute();

      if (res.hasError) {
        context.showErrorSnackBar(message: res.error!.message);
      } else {
        if(res.data.toString() == "[]"){
          // No record in profile table
          // Insert profile into database (profiles table)
          var res = await supabase
              .from('profiles')
              .insert([
            {
              'id': supabase.auth.currentUser!.id,
              'updated_at': DateTime.now().toIso8601String(),
              'username': "Some beta user",
              'avatar_url': "default.jpg",
            }
          ]).execute();
          if(res.hasError){
            context.showErrorSnackBar(message: res.error!.message);
          }else{
            Navigator.pushNamed(context, '/routing');
          }
        }else {
          final user_name = res.data[0]['username'];
          context.showSnackBar(message: 'Welcome $user_name!');
          Navigator.pushNamed(context, '/routing');
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
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    "Back2Campus",
                    style: TextStyle(
                        color: Color(0xff003d7c),
                        fontWeight: FontWeight.w900,
                        // fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                        fontSize: 40
                    ),
                  ),
                ),
                Image.asset('images/logo.png'),
                const Text(
                  "An easier navigation around NUS",
                  style: TextStyle(
                    color: Color(0xff003d7c),
                    //fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
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
                      _signIn();
                    },
                    child: Text('SIGN IN'),
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
