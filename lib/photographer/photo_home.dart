 
import 'package:captura_lens/constants.dart';
import 'package:captura_lens/photographer/photo_activity.dart';
import 'package:captura_lens/photographer/photo_add_post.dart';
import 'package:captura_lens/photographer/photo_home_details.dart';
import 'package:captura_lens/photographer/photo_notification.dart';
import 'package:captura_lens/photographer/photo_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PhotoHome extends StatefulWidget {
  const PhotoHome({super.key});

  @override
  State<PhotoHome> createState() => _PhotoHomeState();
}

class _PhotoHomeState extends State<PhotoHome> {
  int _selectedIndex = 0;

  // void showImagePickerOptions(BuildContext context) {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.lightBlueAccent,
  //       context: context,
  //       builder: (builder) {
  //         return SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.height / 5,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               IconButton(
  //                   onPressed: () {
  //                     _pickImageFromGallery();
  //                   },
  //                   icon: Icon(
  //                     Icons.image,
  //                     size: 50,
  //                   )),
  //               IconButton(
  //                   onPressed: () {
  //                     _pickImageFromCamera();
  //                   },
  //                   icon: Icon(
  //                     CupertinoIcons.camera,
  //                     size: 50,
  //                   ))
  //             ],
  //           ),
  //         );
  //       });
  // }
  //
  // Uint8List? _image;
  // File? selectedImage;
  //
  // Future _pickImageFromGallery() async {
  //   final returnImage =
  //   await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (returnImage == null) return;
  //   setState(() {
  //     selectedImage = File(returnImage.path);
  //     _image = File(returnImage.path).readAsBytesSync();
  //   });
  //   Navigator.of(context).pop(); //Close the model-sheet
  // }
  //
  // Future _pickImageFromCamera() async {
  //   final returnImage =
  //   await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (returnImage == null) return;
  //   setState(() {
  //     selectedImage = File(returnImage.path);
  //     _image = File(returnImage.path).readAsBytesSync();
  //   });
  //   Navigator.of(context).pop();
  // }

  final List<Widget> _widgetOptions = <Widget>[
    const PhotoHomeDetails(),
    const PhotoActivity(),
    const PhotoAddPost(),
    const PhotoNotification(),
    PhotoProfile(
      isPhoto: true,
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.buttonGrey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.view_comfy_alt_sharp,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: '')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black12,
        onTap: _onItemTapped,
        showSelectedLabels: false,
      ),
    );
  }
}
