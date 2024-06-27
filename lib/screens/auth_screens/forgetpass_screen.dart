import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_app/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();

    try {
      // Check if the email exists in the Firestore users collection
      final querySnapshot = await _firestore
          .collection('users') // Assuming you have a 'users' collection
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Email exists, send the password reset email
        await _auth.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Password reset email sent. Check your inbox.')),
        );
        Navigator.of(context).pop(); // Go back to login screen
      } else {
        // Email does not exist in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No account found with this email.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else {
        message = 'An error occurred. Please try again later.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 249),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 249, 249),
          title: Text(
            "Forget Password",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MyTextfield('Email', false, _emailController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.blueAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('Reset Password'),
            )
          ],
        ),
      ),
    );
  }
}
