import 'package:ecom_app/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> initializeUserDocument(User user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Check if the document already exists
    DocumentSnapshot doc = await users.doc(user.uid).get();

    if (!doc.exists) {
      // Document does not exist, initialize it
      await users.doc(user.uid).set({
        'favorites': [],
        'cart': [],
      });
    }
  }

  // Ensure user document exists
  Future<void> ensureUserDocumentExists() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();
      if (!userDoc.exists) {
        await userCollection.doc(user.uid).set({
          'favorites': [],
          'cart': [],
        });
      }
    }
  }

  // Add to favorites
  Future<void> addToFavorites(String productId) async {
    await ensureUserDocumentExists();
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await userCollection.doc(user.uid).update({
          'favorites': FieldValue.arrayUnion([productId])
        });
      } catch (e) {
        debugPrint("Failed to add to favorites: $e");
      }
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String productId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await userCollection.doc(user.uid).update({
          'favorites': FieldValue.arrayRemove([productId])
        });
      } catch (e) {
        debugPrint("Failed to remove from favorites: $e");
      }
    }
  }

  // Add to cart
  Future<void> addToCart(Product product) async {
    await ensureUserDocumentExists();
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await userCollection.doc(user.uid).update({
          'cart': FieldValue.arrayUnion([product.toFirestore()])
        });
      } catch (e) {
        debugPrint("Failed to add to cart: $e");
      }
    }
  }

  // Remove from cart
  Future<void> removeFromCart(Product product) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await userCollection.doc(user.uid).update({
          'cart': FieldValue.arrayRemove([product.toFirestore()])
        });
      } catch (e) {
        debugPrint("Failed to remove from cart: $e");
      }
    }
  }

  // Fetch user favorites
  Future<List<String>> fetchFavorites() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await userCollection.doc(user.uid).get();
        List<String> favorites = List<String>.from(doc['favorites']);
        return favorites;
      } catch (e) {
        debugPrint("Failed to fetch favorites: $e");
        return []; // Return an empty list on error
      }
    }
    return []; // Return an empty list if user is null
  }

  // Fetch user cart
  Future<List<Product>> fetchCart() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await userCollection.doc(user.uid).get();
        List<dynamic> cart = doc['cart'];
        List<Product> products =
            cart.map((item) => Product.fromFirestore(item)).toList();
        return products;
      } catch (e) {
        debugPrint("Failed to fetch cart: $e");
        return []; // Return an empty list on error
      }
    }
    return []; // Return an empty list if user is null
  }
}
