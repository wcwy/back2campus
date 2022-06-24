import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:back2campus/utils/constants.dart';


class UploadLayout extends StatefulWidget {
  const UploadLayout({Key? key}) : super(key: key);

  @override
  State<UploadLayout> createState() => _UploadLayoutState();
}

class _UploadLayoutState extends State<UploadLayout> {
  TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {

    return Container(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 40.0,
              ),
              Text(
                "You may assist to upload $chosenDestination's internal layout below.\n\nAcceptable layouts are:\n1) Floor Plan\n2) 3D Building Model",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans',
                    fontSize: 15
                ),
              ),
              Container(
                height: 40.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.95,
                child: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Enter the Layout Description (Mandatory)',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: 'Eg.: Basement/Level 1/3D Model',
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

              Container(
                height: 40.0,
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
              Container(
                height: 40.0,
              ),
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: Text("SUBMIT"),
              ),
              Container(
                height: 40.0,
              ),
            ],
          ),
        )
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
      });
    }
  }

  /// Upload photo to database
  _uploadImage() async {
    // Check that both description and image are filled by user
    if (descriptionController.text == "" || imageFile == null){
      context.showErrorSnackBar(message: "Please upload a photo and complete the description field");
    }else{
      final bytes = await imageFile!.readAsBytes();
      final fileExt = imageFile!.path.split('.').last;
      final description = descriptionController.text;
      final fileName = '$chosenDestination\_$description.$fileExt';
      final filePath = fileName;
      // Upload the image chosen to supabase storage
      final response = await supabase.storage.from('layoutmaps').uploadBinary(filePath, bytes);
      final error = response.error;
      setState(() {
        // Set variable to null to prevent user from submitting same image
        imageFile = null;
      });
      if (error != null) {
        context.showErrorSnackBar(message: error.message);
      }else{
        // Find location id of the destination
        final res = await supabase
            .from('locations')
            .select('location_id')
            .eq('location_name', chosenDestination)
            .execute();
        if(res.hasError){
          context.showErrorSnackBar(message: res.error!.message);
        }else{
          // Store the location id of destination
          final location_id = res.data[0]['location_id'];
          // Insert the description and the filename stored to database (layouts table)
          final res2 = await supabase
              .from('layouts')
              .insert([
            {'location_id': location_id, 'floor_level': descriptionController.text, 'layoutmap_url': filePath}
          ]).execute();
          if(res2.hasError){
            context.showErrorSnackBar(message: res2.error!.message);
          }else{
            context.showSnackBar(message: 'Successfully uploaded layout!');
            Navigator.pushNamed(context, '/routing');
          }
        }
      }
    }

  }
}