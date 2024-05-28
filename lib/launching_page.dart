import 'package:captura_lens/admin/admin_login.dart';
import 'package:captura_lens/photographer/photo_login_signup.dart';
import 'package:captura_lens/user/user_login_signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

 

class LaunchingPage extends StatefulWidget {
  const LaunchingPage({super.key});

  @override
  State<LaunchingPage> createState() => _LaunchingPageState();
}

class _LaunchingPageState extends State<LaunchingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              foregroundColor: Color.fromARGB(255, 69, 68, 68),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AdminLogin()));
            },
            child: const Text(
              'Admin',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Icon(Icons.security),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Center(
        child: Column(
      
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset("assets/captura_logo.png",scale: 2,),
            ),
            SizedBox(height: 150,),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * .5,  
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhotoLoginSignUp()));
                },
                child: const Text('Photographer Login'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * .5,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white)),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserLoginSignUp()));
                },
                child: const Text('User Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
