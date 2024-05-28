 
import 'package:captura_lens/firebase_options.dart';
 
import 'package:captura_lens/services/admin_controller.dart';
import 'package:captura_lens/services/payment_controller.dart';
import 'package:captura_lens/services/photographer_controller.dart';
import 'package:captura_lens/services/user_controller.dart';
import 'package:captura_lens/splash_screen.dart';
 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 
 
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PhotographerController>(
            create: (_) => PhotographerController()),
        ChangeNotifierProvider<AdminController>(
            create: (_) => AdminController()),
        ChangeNotifierProvider<UserController>(create: (_) => UserController()),
         ChangeNotifierProvider<PaymentController>(create: (_) => PaymentController())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Captura Lens',
        home: SplashScreen(),
      ),
    );
  }
}


// this all ready 