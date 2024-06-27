import 'package:ecom_app/starting_screen.dart';
import 'package:ecom_app/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Menu',
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Navigate to home screen
            },
          ),
          
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('My Cart'),
            onTap: () {
              // Navigate to cart screen
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favourites'),
            onTap: () {
              // Navigate to wishlist screen
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Navigate to profile screen
            },
          ),
        ],
      ),
    );
  }
}
