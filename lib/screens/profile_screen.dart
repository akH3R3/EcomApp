import 'dart:io';
import 'package:ecom_app/screens/auth_screens/login_screen.dart';
import 'package:ecom_app/screens/setting_screen.dart';
import 'package:ecom_app/widgets/my_button.dart';
import 'package:ecom_app/widgets/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _nameController.text = prefs.getString('name') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';
    _bioController.text = prefs.getString('bio') ?? '';
    String? imagePath = prefs.getString('profileImage');
    if (imagePath != null && imagePath.isNotEmpty) {
      _profileImage = File(imagePath);
    }
  });
}

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setString('bio', _bioController.text);
    if (_profileImage != null) {
      await prefs.setString('profileImage', _profileImage!.path);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Clear local storage data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginScreen())); // Navigate to login screen or desired route
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            
            icon: const Icon(Icons.settings,size: 27),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(),
                  ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage == null
                        ? AssetImage('assets/user_photo.jpeg')
                        : FileImage(_profileImage!) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 21, right: 21, bottom: 10),
                child: TextField(
                  controller: _bioController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    hintText: 'Write something about yourself...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 3, bottom: 7),
                child: MyTextfield('Name', false, _nameController),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 3, bottom: 7),
                child: MyTextfield('Email', false, _emailController),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 3, bottom: 7),
                child: MyTextfield('Phone', false, _phoneController),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 3, bottom: 7),
                child: MyTextfield('Password', true, _passwordController),
              ),
              SizedBox(height: 5),
              MyButton(
                  text: 'Save Profile',
                  onPressed: () {
                    _saveProfileData();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Profile Updated'),
                    ));
                  }),
              SizedBox(height: 12),
              MyButton(
                  text: 'Logout',
                  onPressed: () {
                    _logout();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
