import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width*0.8,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
                      child: const Text(
                        "Back2Campus",
                        style: TextStyle(
                            color: Color(0xff003d7c),
                            fontWeight: FontWeight.w900,
                            // fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 40
                        ),
                      )
                  ),
                  Image.asset('assets/images/logo.png'),
                  const Text(
                    "An easier navigation around NUS",
                    style: TextStyle(
                        color: Color(0xff003d7c),
                        //fontStyle: FontStyle.italic,
                        fontFamily: 'Open Sans',
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
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
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text('CREATE ACCOUNT'),
                      )
                  ),
                  ElevatedButton(
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
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: Text('SIGN IN'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}