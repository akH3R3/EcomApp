import 'package:ecom_app/screens/auth_screens/forgetpass_screen.dart';
import 'package:ecom_app/screens/auth_screens/signup_screen.dart';
import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/splash_screen.dart';
import 'package:ecom_app/widgets/my_button.dart';
import 'package:ecom_app/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailTextController = TextEditingController();

  TextEditingController _passwordTextController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );

      // Save user data locally
      await _saveUserData(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );

      // Navigate to the next screen after successful login
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData(
      {required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 243, 240, 240),
            appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 243, 240, 240),
                title: Text(
                  "I have an account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            body: _isLoading
                ? Center(child: CircularProgressIndicator(
                  color: Colors.black,
                ))
                : SingleChildScrollView(
                    child: Center(
                        child: Column(children: [
                    Image.asset(
                      'assets/ecom_logo.png',
                      height: 300,
                      width: 300,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 15),
                        child:
                            MyTextfield('Email', false, _emailTextController)),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 12),
                        child: MyTextfield(
                            'Password', true, _passwordTextController)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassScreen()));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text('Forget Password?'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyButton(
                        text: 'Login',
                        onPressed: () {
                          _signInWithEmailAndPassword();
                        }),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Text("Don't have an account? Register Now"),
                      ),
                    ),
                  ])))));
  }
}
