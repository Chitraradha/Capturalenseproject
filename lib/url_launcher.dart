import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URLlaunchers extends StatefulWidget {
  const URLlaunchers({super.key});

  @override
  State<URLlaunchers> createState() => _URLlaunchersState();
}

class _URLlaunchersState extends State<URLlaunchers> {

  final Uri _url = Uri.parse('https://flutter.dev');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _launchUrl,
          child: Text('Show Flutter homepage'),
        ),
      ),
    );
  }
}
