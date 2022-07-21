import 'package:flutter/material.dart';
import 'package:back2campus/utils/constants.dart';
import 'dart:convert';
// Namespace needed to prevent conflict for text()
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

class ViewroutePage extends StatefulWidget {
  const ViewroutePage({Key? key}) : super(key: key);

  @override
  State<ViewroutePage> createState() => _ViewroutePageState();
}

class _ViewroutePageState extends State<ViewroutePage> {
  flutter_quill.QuillController _controller = flutter_quill.QuillController.basic();
  List routeList = [];
  var _writerprofilepicurl = "https://rlemxzljabcaylnhetcv.supabase.co/storage/v1/object/public/avatars/default.jpg";
  var _title = "";
  var _author = "";
  var _postedtime = "";

  /// Retrieve route information from database based on the route selected by user (stored in $routeselected)
  Future<void> _retrieveRoute() async {
    // Retrieve route complete info from database
    var res = await supabase
        .from('routes')
        .select('route_id, user_id, route_description, last_edited_time, route_content')
        .eq('route_id', routeselected)
        .execute();

    if (res.hasError) {
      context.showErrorSnackBar(message: res.error!.message);
    } else {
      // Store the route retrieved as local variable
      setState(() {
        routeList = res.data;
        var myJSON = jsonDecode(res.data[0]['route_content']);
        _controller = flutter_quill.QuillController(
            document: flutter_quill.Document.fromJson(myJSON),
            selection: TextSelection.collapsed(offset: 0));
        _title = routeList[0]["route_description"];
        _postedtime = (res.data[0]['last_edited_time']).substring(0,10);
      });

      // Retrieve the username and profile pic of route writer
      res = await supabase
          .from('profiles')
          .select('id, username, avatar_url')
          .eq('id', routeList[0]['user_id'])
          .execute();

      if (res.hasError) {
        context.showErrorSnackBar(message: res.error!.message);
      } else {
        // Store the information received as local variable
        setState(() {
          _author = res.data[0]['username'];

          _writerprofilepicurl = supabase.storage.from('avatars').getPublicUrl(res.data[0]['avatar_url']).data!;
        });
      }
    }
  }

  @override
  void initState() {
    _retrieveRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
          toolbarHeight: 100,
          title: Text("$chosenSource => $chosenDestination"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/shared');
            },
            icon: const Icon(Icons.arrow_back),
          )
      ),
      body: Container(
          alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: ResizeImage(
                            NetworkImage(_writerprofilepicurl),
                            height: 137,
                            width: 137
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text(
                            "Author: $_author",
                          ),
                          Text(
                            "Posted at: $_postedtime",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Text(
                    _title,
                    style: const TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.double,
                    ),
                  ),
                ),
                Container(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.95,
                    color: Colors.white38,
                    child: flutter_quill.QuillEditor.basic(
                      controller: _controller,
                      readOnly: true, // true for view only mode
                    ),
                  ),
                ),
              ],
            )
        ),
    );
  }
}
