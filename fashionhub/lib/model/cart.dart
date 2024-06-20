import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:fashionhub/model/userCart.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  List<Clother> cloShop = [];
  List<UserCart> userCart = [];
  final AuthenticationService _authenticationService;

  Cart(this._authenticationService) {
    fetchClotherList();
    fetchUserCart();
  }

  Future<void> fetchClotherList() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final List<Clother> fetchedClothes = querySnapshot.docs.map((doc) {
        return Clother(
          name: doc['name'],
          price: doc['price'],
          imagePath: doc['imagePath'],
          description: doc['description'],
          brand: doc['brand'],
          color: doc['color'],
          size: doc['size'],
          evaluate: doc['evaluate'].toDouble(),
          sold: doc['sold'],
          wareHouse: doc['wareHouse'],
        );
      }).toList();
      cloShop = fetchedClothes;
      notifyListeners();
    } catch (e) {
      print('Error fetching clothes: $e');
    }
  }

  Future<void> fetchUserCart() async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userCart')
          .where('uid', isEqualTo: uid)
          .get();
      final List<UserCart> fetchedCartItems = querySnapshot.docs.map((doc) {
        return UserCart.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      userCart = fetchedCartItems;
      notifyListeners();
    } catch (e) {
      print('Error fetching user cart: $e');
    }
  }

  List<Clother> getClotherList() {
    return cloShop;
  }

  List<UserCart> getUserCart() {
    return userCart;
  }

  List<String> getBranchesList() {
    Set<String> brandesSet = {};
    for (var item in cloShop) {
      brandesSet.add(item.brand);
    }
    return brandesSet.toList();
  }

  Future<void> addItemToCart(Clother clother, int quantity, String size) async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      bool productExists = false;
      for (var item in userCart) {
        if (item.name == clother.name &&
            item.size == size &&
            item.color == clother.color) {
          item.quantity += quantity;
          productExists = true;
          break;
        }
      }
      if (!productExists) {
        UserCart cartItem = UserCart(
          name: clother.name,
          price: clother.price.toDouble(),
          imagePath: clother.imagePath,
          description: clother.description,
          brand: clother.brand,
          color: clother.color,
          size: size,
          evaluate: clother.evaluate,
          sold: clother.sold,
          wareHouse: clother.wareHouse,
          quantity: quantity,
          uid: uid,
        );
        userCart.add(cartItem);

        // Add new item to Firestore
        await FirebaseFirestore.instance.collection('userCart').add({
          'name': cartItem.name,
          'price': cartItem.price,
          'imagePath': cartItem.imagePath,
          'description': cartItem.description,
          'brand': cartItem.brand,
          'color': cartItem.color,
          'size': cartItem.size,
          'quantity': cartItem.quantity,
          'uid': uid,
        });
      } else {
        // Update quantity of existing item in Firestore
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('userCart')
            .where('name', isEqualTo: clother.name)
            .where('size', isEqualTo: size)
            .where('color', isEqualTo: clother.color)
            .where('uid', isEqualTo: uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            await FirebaseFirestore.instance
                .collection('userCart')
                .doc(doc.id)
                .update({'quantity': FieldValue.increment(quantity)});
          }
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  List<Clother> sortClotherList(String sortOption) {
    List<Clother> sortedList = List.from(cloShop);
    switch (sortOption) {
      case 'Giá từ thấp đến cao':
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Giá từ cao đến thấp':
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lượt bán':
        sortedList.sort((a, b) => b.sold.compareTo(a.sold));
        break;
      case 'Đánh giá':
        sortedList.sort((a, b) => b.evaluate.compareTo(a.evaluate));
        break;
      default:
        break;
    }
    return sortedList;
  }

  Future<void> removeItemFromCart(UserCart clother) async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      for (var item in userCart) {
        if (item.name == clother.name &&
            item.size == clother.size &&
            item.color == clother.color) {
          if (item.quantity > 1) {
            item.quantity -= 1;

            // Update Firestore quantity
            QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection('userCart')
                .where('name', isEqualTo: clother.name)
                .where('size', isEqualTo: clother.size)
                .where('color', isEqualTo: clother.color)
                .where('uid', isEqualTo: uid)
                .get();
            if (snapshot.docs.isNotEmpty) {
              for (var doc in snapshot.docs) {
                await FirebaseFirestore.instance
                    .collection('userCart')
                    .doc(doc.id)
                    .update({'quantity': FieldValue.increment(-1)});
              }
            }
          } else {
            userCart.remove(item);

            // Remove from Firestore
            QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection('userCart')
                .where('name', isEqualTo: clother.name)
                .where('size', isEqualTo: clother.size)
                .where('color', isEqualTo: clother.color)
                .where('uid', isEqualTo: uid)
                .get();
            for (var doc in snapshot.docs) {
              await FirebaseFirestore.instance
                  .collection('userCart')
                  .doc(doc.id)
                  .delete();
            }
          }
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  Future<void> updateItemQuantity(UserCart clother, int quantity) async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      for (var item in userCart) {
        if (item.name == clother.name &&
            item.size == clother.size &&
            item.color == clother.color) {
          item.quantity = quantity;

          // Update Firestore quantity
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('userCart')
              .where('name', isEqualTo: clother.name)
              .where('size', isEqualTo: clother.size)
              .where('color', isEqualTo: clother.color)
              .where('uid', isEqualTo: uid)
              .get();
          if (snapshot.docs.isNotEmpty) {
            for (var doc in snapshot.docs) {
              await FirebaseFirestore.instance
                  .collection('userCart')
                  .doc(doc.id)
                  .update({'quantity': quantity});
            }
          }
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('Error updating item quantity: $e');
    }
  }

  Future<void> removeItems(List<UserCart> items) async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      for (var item in items) {
        userCart.remove(item);
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('userCart')
            .where('name', isEqualTo: item.name)
            .where('size', isEqualTo: item.size)
            .where('color', isEqualTo: item.color)
            .where('uid', isEqualTo: uid)
            .get();

        for (var doc in snapshot.docs) {
          await FirebaseFirestore.instance
              .collection('userCart')
              .doc(doc.id)
              .delete();
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error removing items from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      userCart.clear();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userCart')
          .where('uid', isEqualTo: uid)
          .get();

      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('userCart')
            .doc(doc.id)
            .delete();
      }
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in userCart) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
