import 'package:captura_lens/admin/admin_event_post.dart';
import 'package:captura_lens/forgot_password.dart';
import 'package:captura_lens/model/photographer_model.dart';
import 'package:captura_lens/photographer/photo_home.dart';
import 'package:captura_lens/photographer/photo_send_otp.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';

import '../constants.dart';

class PhotoLoginSignUp extends StatefulWidget {
  const PhotoLoginSignUp({super.key});

  @override
  State<PhotoLoginSignUp> createState() => _PhotoLoginSignUpState();
}

class _PhotoLoginSignUpState extends State<PhotoLoginSignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _name=TextEditingController();

  String selecteType = "";
  bool _isLogin = true;
  bool _isChecked = false;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CupertinoColors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CupertinoColors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLogin
                              ? 'Go ahead and setup Your account'
                              : 'Register yourself',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: CupertinoColors.white),
                        ),
                        Text(
                          _isLogin
                              ? 'Sign in-up to enjoy the best managing experience'
                              : 'Complete the form below to get start',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                              color: CupertinoColors.systemGrey4),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        width: double.maxFinite,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isLogin = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _isLogin
                                        ? CustomColors.backgroundWhite
                                        : null,
                                  ),
                                  child: Text(
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _isLogin
                                          ? Colors.black
                                          : CustomColors.buttonGrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isLogin = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _isLogin
                                        ? null
                                        : CustomColors.backgroundWhite,
                                  ),
                                  child: Text(
                                    'Register',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _isLogin
                                          ? CustomColors.buttonGrey
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if(!_isLogin)
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.perm_identity,
                        color: CustomColors.buttonGreen,),
                        hintText: "Name",
                        border: OutlineInputBorder(
                        ),
                      
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: CustomColors.buttonGreen,
                          ),
                          hintText: 'Email Address',
                          border: OutlineInputBorder()),
                      controller: _emailController,
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Please enter your email';
                        }

                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(email)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: CustomColors.buttonGreen,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: _isObscured
                                ? const Icon(CupertinoIcons.eye_slash)
                                : const Icon(CupertinoIcons.eye),
                            color: CustomColors.buttonGreen,
                          ),
                          border: const OutlineInputBorder()),
                      obscureText: _isObscured,
                      controller: _passwordController,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (password!.length < 6) {
                          return "Password should be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: CustomColors.buttonGreen,
                            ),
                            border: OutlineInputBorder()),
                        obscureText: true,
                        controller: _confirmPasswordController,
                        validator: (confirmPassword) {
                          return _passwordController.text !=
                                  _confirmPasswordController.text
                              ? "Passwords Does not match"
                              : null;
                        },
                      ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Place',
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: CustomColors.buttonGreen,
                            ),
                            border: OutlineInputBorder()),
                        controller: _placeController,
                        validator: (place) {
                          return place!.isEmpty ? "Enter a place" : null;
                        },
                      ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      DropdownButtonFormField(
                          decoration: const InputDecoration(
                              hintText: 'Type of Photography',
                              prefixIcon: Icon(
                                Icons.view_list,
                                color: CustomColors.buttonGreen,
                              ),
                              border: OutlineInputBorder()),
                          items: photographyTypes.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (selectedValue) {
                            selecteType = selectedValue!;
                            // setState(() {});
                          }),

                    // TextFormField(
                    // decoration: const InputDecoration(
                    //     hintText: 'Type of Photography',
                    //     prefixIcon: Icon(
                    //       Icons.view_list,
                    //       color: CustomColors.buttonGreen,
                    //     ),
                    //     border: OutlineInputBorder()),
                    //   controller: _typeController,
                    //   validator: (type) {
                    //     return type!.isEmpty ? "Enter Type to begin" : null;
                    //   },
                    // ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Aadhaar Number',
                            prefixIcon: Icon(
                              Icons.perm_identity_sharp,
                              color: CustomColors.buttonGreen,
                            ),
                            border: OutlineInputBorder()),
                        controller: _aadhaarController,
                        validator: (aadhaar) {
                          return aadhaar!.length != 12
                              ? "Enter a valid aadhaar"
                              : null;  
                        },
                      ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            prefixIcon: Icon(
                              Icons.phone_android,
                              color: CustomColors.buttonGreen,
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        validator: ([phone]) {
                          return phone!.isEmpty ? "Enter a valid Number" : null;
                        },
                      ),
                    if (_isLogin)
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhotoSendOTP()));
                              },
                              child: const Text(
                                "Login with OTP ?",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (_isLogin)
                      Row(
                        children: [
                          Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              }),
                          const Text(
                            "Remember Me",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword()));
                              },
                              child: const Text("Forgot Password?"))
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create a new account? Register'
                            : 'Already have an account? Login',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            foregroundColor: Colors.white,
                            backgroundColor: CustomColors.buttonGreen),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _isLogin
                                ? FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text)
                                    .then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PhotoHome()));
                                  }).onError((error, stackTrace) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(error.toString())));
                                  })
                                : selecteType.isNotEmpty
                                    ? FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text)
                                        .then((value) async {
                                        await PhotographerController()
                                            .addPhotoDetails(
                                                PhotographerModel(
                                                    profileUrl: "",
                                                    adherNumber: int.parse(
                                                        _aadhaarController
                                                            .text),
                                                    email:
                                                        _emailController.text,
                                                    id: value.user!.uid,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                    phoneNumber: int.parse(
                                                        _phoneController.text),
                                                    place:
                                                        _placeController.text,
                                                    typePhotographer:
                                                        selecteType,
                                                        name: _name.text
                                                        ),
                                                value.user!.uid);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PhotoHome()));
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(error.toString())));
                                      })
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text("Select type ")));
                          }
                        },
                        child: Text(_isLogin ? 'Login' : 'Register'),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
