import 'dart:io';
import 'dart:typed_data';

import 'package:captura_lens/model/add_post.dart';
import 'package:captura_lens/photographer/photo_home.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';


class PhotoAddPost extends StatefulWidget {
  const PhotoAddPost({super.key});

  @override
  State<PhotoAddPost> createState() => _PhotoAddPostState();
}

class _PhotoAddPostState extends State<PhotoAddPost> {
  Uint8List? _image;
  File? selectedImage;
  String imageURL = '';
  dynamic editedImage;

  Future<File?> _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage != null) {
      setState(() {
        _image = File(returnImage.path).readAsBytesSync();
        selectedImage = File(returnImage.path);
      });
    }
    return selectedImage;
  }

  Future<File?> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage != null) {
      setState(() {
        _image = File(returnImage.path).readAsBytesSync();
        selectedImage = File(returnImage.path);
      });
    }
    return selectedImage;
  }

  File? imageFilePlace;

  final firebaseStorage = FirebaseStorage.instance;
  String uniqueImageName = DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PhotoHome()));
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _pickImageFromGallery().then((file) async {
                  if (file != null) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ImageEditor(
                                  image: file,
                                )))
                        .then((edited) {
                      setState(() {
                        editedImage = edited;
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Image not selected")));
                  }
                });
              },
              child: const Text("Gallery")),
          TextButton(
              onPressed: () async {
                _pickImageFromCamera().then((file) async {
                  if (file != null) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ImageEditor(
                                  image: file,
                                )))
                        .then((edited) {
                      setState(() {
                        editedImage = edited;
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Image not selected")));
                  }
                });
              },
              child: const Text("Camera"))
        ],
      ),
      body: Column(
        children: [
          Builder(builder: (context) {
            return Expanded(
                child: editedImage != null
                    ? Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(editedImage!))),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.white)),
                        child: const Center(child: Text("Select Photo")),
                      ));
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedImage != null) {
            SettableMetadata metadata =
                SettableMetadata(contentType: "image/jpeg");
            Reference referenceDirImage =
                FirebaseStorage.instance.ref().child('images');
            Reference referenceImageToUpload = referenceDirImage.child(
              uniqueImageName,
            );
            try {
              await referenceImageToUpload.putData(editedImage!, metadata);
              imageURL = await referenceImageToUpload.getDownloadURL();
            } catch (error) {
              print(error);
            }
            String id = randomAlphaNumeric(10);

            await PhotographerController()
                .photoPost(
                    AddPost(
                        imageUrl: imageURL,
                        postId: id,
                        uid: FirebaseAuth.instance.currentUser!.uid),
                    id)
                .then((value) {
              Fluttertoast.showToast(
                  msg: "Photo Successfully Uploaded",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }).then((value) {
              setState(() {
                _image = null;
                editedImage = null;
                selectedImage = null;
                imageURL = "";
              });
            });
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Pick file")));
          }
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        child: const Text("Done"),
      ),
    );
  }
}
