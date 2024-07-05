import 'package:ecom_app/models/product.dart';
import 'package:ecom_app/services/user_service.dart';
import 'package:ecom_app/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final UserService _userService = UserService();
  List<Product> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    List<Product> cartItems = await _userService.fetchCart();
    setState(() {
      _cartItems = cartItems;
    });
  }

  Future<void> _removeFromCart(Product product) async {
    await _userService.removeFromCart(product);
    _fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Cart'),
      body: _cartItems.isEmpty
          ? Center(child: Text('Your cart is empty', 
          style: TextStyle(
            fontSize: 18,
            color: Colors.black
          ),))
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final product = _cartItems[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(product.image, width: 50, height: 50),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        _removeFromCart(product);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
