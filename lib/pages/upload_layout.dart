import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:back2campus/utils/constants.dart';


class UploadLayout extends StatefulWidget {
  const UploadLayout({Key? key}) : super(key: key);

  @override
  State<UploadLayout> createState() => _UploadLayoutState();
}

class _UploadLayoutState extends State<UploadLayout> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.blueGrey
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "No image is available for this building currently.\nAssist to upload one:",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Open Sans',
                    fontSize: 15
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
                height: 40.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightGreenAccent),
                ),
                onPressed: () {
                  _getFromCamera();
                },
                child: Text("PICK FROM CAMERA"),
              )
            ],
          ),
        )
    );
  }
  /// Get from gallery
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
      _uploadImage();
    }
  }

  /// Get from Camera
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
      _uploadImage();
    }
  }

  /// Upload photo to database
  _uploadImage() async {
    final bytes = await imageFile!.readAsBytes();
    final fileExt = imageFile!.path.split('.').last;
    final fileName = '$chosenDestination.$fileExt';
    final filePath = fileName;
    final response = await supabase.storage.from('layoutmaps').uploadBinary(filePath, bytes);

    final error = response.error;
    setState(() {
      imageFile = null;
    });
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'Successfully uploaded layout!');
      Navigator.pushNamed(context, '/routing');
    }
  }
}
