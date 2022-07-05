import 'package:flutter/material.dart';
import 'package:back2campus/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var username = "";
  var quote = "";

  // Sign out
  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }else{
      Navigator.pushNamed(context, '/');
    }
  }
  // Retrieve profile information from database
  Future<void> _retrieveProfiles() async {
    var res = await supabase
        .from('profiles')
        .select('id, username, quote')
        .eq('id', supabase.auth.currentUser!.id)
        .execute();

    if (res.hasError) {
      context.showErrorSnackBar(message: res.error!.message);
    } else {
      setState(() {
        username = res.data[0]['username'];
        if(res.data[0]['quote'] == null){
          //quote = "For wakanda";
          quote = "[Default] Chaos isn't a pit. Chaos is a ladder. Many who try to climb it fail and never get to try it again. The fall breaks them. And some are given a chance to climb. They refuse. They cling to the realm or the gods or love. Illusions. Only the ladder is real. The climb is all there is.";
        }else{
          quote = res.data[0]['quote'];
        }
      });

    }
  }

  @override
  void initState() {
    _retrieveProfiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("Your profile"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/routing');
        },
        icon: const Icon(Icons.home),
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              color: Colors.blueGrey
          ),
          child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                ),
                CircleAvatar(
                  radius: 125.0,
                  backgroundImage:
                      NetworkImage(profilepicurl),
                ),
                Container(
                  height: 20,
                ),
                Text(
                    "$username",
                ),
                Container(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 105,
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        "\"$quote\"",
                        textAlign: TextAlign.justify,
                      )
                    )
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/editprofile');
                      },
                      child: const Text('Edit Profile'),
                    ),
                    Container(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        _signOut();
                      },
                      child: const Text('Sign Out'),
                    ),
                  ]
                ),

              ],
          ),
        ),
      ),
    );
  }
}
