import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(
              fontWeight: FontWeight.bold,fontSize: 25),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.black,
        child: const Column(
          children: [
            Expanded(
              child: Text(
                "Introducing CaptureLens, the must-have mobile app for event organizers and photographers alike. Easily find and book photographers for your special occasions, from weddings to corporate events. Browse through a diverse directory of talented photographers, view their portfolios, and choose based on your preferences. Host your event within the app, creating a dedicated space for photographers to showcase their work. Receive real-time updates on your booking status and communicate directly with your chosen photographer. After the event, enjoy a centralized gallery of all the captured moments. Leave feedback and ratings, building a trustworthy community. With CaptureLens, simplify the process of finding, booking, and managing photographers for your events. Download now and capture your moments effortlessly!",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
