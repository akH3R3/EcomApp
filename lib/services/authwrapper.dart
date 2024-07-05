import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/onboarding_screen.dart';
import 'package:ecom_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return SplashScreen();
        } else {
          return OnBoardingScreen();
        }
      },
    );
  }
}
