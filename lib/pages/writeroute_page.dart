import 'package:flutter/material.dart';
import 'package:back2campus/utils/constants.dart';
import 'dart:convert';
// Namespace needed to prevent conflict for text()
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

class WriteroutePage extends StatefulWidget {
  const WriteroutePage({Key? key}) : super(key: key);

  @override
  State<WriteroutePage> createState() => _WriteroutePageState();
}

class _WriteroutePageState extends State<WriteroutePage> {
  TextEditingController titleController = TextEditingController();
  final flutter_quill.QuillController _controller = flutter_quill.QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("$chosenSource => $chosenDestination"),
        automaticallyImplyLeading: false,
        // Home button
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/routing');
          },
          icon: const Icon(Icons.home),
        ),
        centerTitle: true,
        // Submit button
        actions: [
          IconButton(
            onPressed: () {
              upload_route();
            },
            icon: const Icon(Icons.share_sharp),
          )
        ],
      ),
      body: Container(
        //color: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 30,
                ),
                Text(
                  "Know a route between $chosenSource and $chosenDestination? Share it here!"
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.95,
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Enter the title for your sharing',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: 'Eg.: Hidden shortcut between CLB and COM2',
                      hintStyle: TextStyle(
                        color: Color(0xFFB3B1B1),
                        fontSize: 12,
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
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 40,
                ),
                Text(
                  "Type your sharing below with the space provided"
                ),
                flutter_quill.QuillToolbar.basic(controller: _controller),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.95,
                    color: Colors.white38,
                    child: flutter_quill.QuillEditor.basic(
                      controller: _controller,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                ),
              ],
            )
        ),
    );
  }

  /// Upload the user entered route into database
  upload_route() async {
    var json = jsonEncode(_controller.document.toDelta().toJson());
    var user_id = supabase.auth.currentUser!.id;
    var source_id = "";
    var destination_id = "";

    // Check that title field and content field are both entered by users
    if(titleController.text == "" || json == "[{\"insert\":\"\\n\"}]" ){
      context.showErrorSnackBar(message: "Please insert both title and content before submitting!");
    }else {
      // Find location id for source
      var res = await supabase
          .from('locations')
          .select('location_id')
          .eq('location_name', chosenSource)
          .execute();

      if (res.hasError) {
        context.showErrorSnackBar(message: res.error!.message);
      } else {
        // Store source location id
        source_id = res.data[0]['location_id'];
        // Find location id for destination
        res = await supabase
            .from('locations')
            .select('location_id')
            .eq('location_name', chosenDestination)
            .execute();
        if (res.hasError) {
          context.showErrorSnackBar(message: res.error!.message);
        } else {
          // Store destination location id
          destination_id = res.data[0]['location_id'];

          // Insert user shared route into database (routes table)
          res = await supabase
              .from('routes')
              .insert([
            {
              'user_id': user_id,
              'src_location_id': source_id,
              'end_location_id': destination_id,
              'route_description': titleController.text,
              'route_content': json,
              'last_edited_time': DateTime.now().toIso8601String()
            }
          ]).execute();

          if (res.hasError) {
            context.showErrorSnackBar(message: res.error!.message);
          } else {
            context.showSnackBar(message: 'Successfully shared route!');
            Navigator.pushNamed(context, '/routing');
          }
        }
      }
    }
  }
}
