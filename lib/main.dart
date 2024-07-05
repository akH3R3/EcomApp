import 'package:ecom_app/providers/cart_provider.dart';
import 'package:ecom_app/providers/favourite_provider.dart';
import 'package:ecom_app/screens/auth_screens/forgetpass_screen.dart';
import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/auth_screens/signup_screen.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/onboarding_screen.dart';
import 'package:ecom_app/screens/splash_screen.dart';
import 'package:ecom_app/services/authwrapper.dart';
import 'package:ecom_app/starting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>FavouriteProvider()),
        ChangeNotifierProvider(create: (_)=>CartProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}

