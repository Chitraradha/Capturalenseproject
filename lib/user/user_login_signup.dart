import 'package:captura_lens/model/user_model.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/user/user_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../forgot_password.dart';

class UserLoginSignUp extends StatefulWidget {
  const UserLoginSignUp({super.key});

  @override
  State<UserLoginSignUp> createState() => _UserLoginSignUpState();
}

class _UserLoginSignUpState extends State<UserLoginSignUp> {
  bool _isLogin = true;
  bool _isChecked = false;
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();

  var emailcontrolller = TextEditingController();
  var passwordcontrolller = TextEditingController();
  var confirmPasswordcontrolller = TextEditingController();
  var placecontrolller = TextEditingController();
  var contctNumbercontrolller = TextEditingController();
  var namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: CupertinoColors.white,
        ),
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
              padding: const EdgeInsets.symmetric(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        width: double.maxFinite,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(34.0),
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
                    const SizedBox(
                      height: 30,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        controller: namecontroller,
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Please enter your name';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_3_outlined,
                              color: CustomColors.buttonGreen,
                            ),
                            hintText: 'name  ',
                            border: OutlineInputBorder()),
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: emailcontrolller,
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
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: CustomColors.buttonGreen,
                          ),
                          hintText: 'Email Address',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordcontrolller,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (password!.length < 6) {
                          return "Password should be at least 6 characters";
                        }
                        return null;
                      },
                      decoration:   InputDecoration(
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
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: CustomColors.buttonGreen,
                          ),
                          border: OutlineInputBorder()),
                      obscureText: _isObscured,
                    ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      TextFormField(
                        controller: confirmPasswordcontrolller,
                        validator: (confirmPassword) {
                          if (confirmPassword!.isEmpty) {
                            return "password is required";
                          }
                          if (confirmPassword != passwordcontrolller.text) {
                            return "Passwords Does not match";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: CustomColors.buttonGreen,
                            ),
                            border: OutlineInputBorder()),
                        obscureText: true,
                      ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      TextFormField(
                        controller: placecontrolller,
                        validator: (place) {
                          return place!.isEmpty ? "Enter a place" : null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Place',
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: CustomColors.buttonGreen,
                            ),
                            border: OutlineInputBorder()),
                      ),
                    const SizedBox(height: 20.0),
                    if (!_isLogin)
                      TextFormField(
                        validator: ([phone]) {
                          return phone!.isEmpty ? "Enter a valid Number" : null;
                        },
                        controller: contctNumbercontrolller,
                        decoration: const InputDecoration(
                            hintText: 'Contact Number',
                            prefixIcon: Icon(
                              Icons.phone_android,
                              color: CustomColors.buttonGreen,
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
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
                                            const ForgotPassword()));
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
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(
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
                            if (_isLogin == true) {
                              UserController().signIn(emailcontrolller.text,
                                  passwordcontrolller.text, context);
                            } else {
                              UserController().userSignup(
                                  emailcontrolller.text,
                                  passwordcontrolller.text,
                                  context,
                                  UserModel(
                                      profileUrl: "",
                                      email: emailcontrolller.text,
                                      password: passwordcontrolller.text,
                                      phoneNumber: int.parse(
                                          contctNumbercontrolller.text),
                                      place: placecontrolller.text,
                                      name: namecontroller.text));
                            }
                          }

                          // _isLogin
                          //     ? Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => const UserHome()))
                          //     : Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => const UserHome()));
                        },
                        child: Text(_isLogin ? 'Login' : 'Register'),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
