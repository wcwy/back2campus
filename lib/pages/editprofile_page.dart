import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:back2campus/utils/constants.dart';


class EditprofilePage extends StatefulWidget {
  const EditprofilePage({Key? key}) : super(key: key);

  @override
  State<EditprofilePage> createState() => _EditprofilePageState();
}

class _EditprofilePageState extends State<EditprofilePage> {
  var username = "";
  var quote = "";
  var currentimagepath = "";
  ImageProvider profilepic = NetworkImage(profilepicurl);
  TextEditingController usernameController = TextEditingController();
  TextEditingController quoteController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  /// Retrieve profile information from database
  Future<void> _retrieveProfiles() async {
    var res = await supabase
        .from('profiles')
        .select('id, username, quote, avatar_url')
        .eq('id', supabase.auth.currentUser!.id)
        .execute();

    if (res.hasError) {
      context.showErrorSnackBar(message: res.error!.message);
    } else {
      setState(() {
        username = res.data[0]['username'];
        currentimagepath = res.data[0]['avatar_url'];
        usernameController.text = username;
        if(res.data[0]['quote'] == null){
          quote = "[Default] Chaos isn't a pit. Chaos is a ladder. Many who try to climb it fail and never get to try it again. The fall breaks them. And some are given a chance to climb. They refuse. They cling to the realm or the gods or love. Illusions. Only the ladder is real. The climb is all there is.";
          quoteController.text = quote;
        }else{
          quote = res.data[0]['quote'];
          quoteController.text = quote;
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
          ),
        actions: [
          IconButton(
            onPressed: () {
              _uploadProfile();
            },
            icon: const Icon(Icons.save),
          )
        ],
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
                  profilepic,
              ),
              Container(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: usernameController,
                  decoration: const InputDecoration(
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
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
                  scrollDirection: Axis.vertical,
                  child: TextField(
                    //autofocus: true,
                    textAlign: TextAlign.justify,
                    controller: quoteController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none, // hide default underline
                      isDense: true,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                )
              ),
              Container(
                height: 20,
              ),

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                ),
                onPressed: () {
                  _getFromGallery();
                },
                child: Text("PICK FROM GALLERY"),
              ),
              Container(
                height: 10.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                ),
                onPressed: () {
                  _getFromCamera();
                },
                child: Text("PICK FROM CAMERA"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get image from gallery
  _getFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        profilepic = FileImage(imageFile!);
      });
    }
  }

  /// Get image from Camera
  _getFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        profilepic = FileImage(imageFile!);
      });
    }
  }

  /// Update profile information to database
  _uploadProfile() async {
    var random = Random.secure();
    var randomvalue = random.nextInt(1000000000); // to be append behind image file name
    if (usernameController.value.text.length < 3) {
      context.showErrorSnackBar(message: 'Minimum 3 characters');
    }else{
      // Check if user selected any profile picture
      if (imageFile != null){
        // A picture is selected, upload that into database first
        var bytes = await imageFile!.readAsBytes();
        final fileExt = imageFile!.path.split('.').last;
        final fileName = supabase.auth.currentUser!.id;
        final filePath = '$fileName\_$randomvalue.$fileExt'; // the image filepath should be unique due to randomvalue

        // Upsert the image chosen to supabase storage
        var response = await supabase.storage.from('avatars').uploadBinary(filePath, bytes);
        if (response.hasError) {
          context.showErrorSnackBar(message: response.error!.message);
        }else{
          setState(() {
            // Set variable to null to prevent user from submitting same image
            imageFile = null;
          });
          // Update the profile table with the path name
          var res = await supabase
              .from('profiles')
              .update({ 'avatar_url': filePath })
              .match({ 'id':  supabase.auth.currentUser!.id})
              .execute();
          if (res.hasError) {
            context.showErrorSnackBar(message: res.error!.message);
          }else{
            // Delete the original image
            if(currentimagepath != "default.jpg"){
              final res = await supabase
                  .storage
                  .from('avatars')
                  .remove([currentimagepath]);
              if (res.hasError) {
                context.showErrorSnackBar(message: res.error!.message);
              }
            }
          }
          // Set the profile picture to be displayed
          setState(() {
            profilepicurl = supabase.storage.from('avatars').getPublicUrl(filePath).data!;
          });
        }
      }

      // Update username to database
      var res = await supabase
          .from('profiles')
          .update({ 'username': usernameController.text })
          .match({ 'id':  supabase.auth.currentUser!.id})
          .execute();
      if (res.hasError) {
        context.showErrorSnackBar(message: res.error!.message);
      }else{
        // Update quote to database
        res = await supabase
            .from('profiles')
            .update({ 'quote': quoteController.text })
            .match({ 'id':  supabase.auth.currentUser!.id})
            .execute();

        if(res.hasError) {
          context.showErrorSnackBar(message: res.error!.message);
        }else{
          context.showSnackBar(message: 'Profile updated.');
          Navigator.pushNamed(context, '/profile');
        }
      }
    }

  }
}
