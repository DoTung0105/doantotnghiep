import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/address_model.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:fashionhub/model/userCart_model.dart';
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

      // Sử dụng Map để chỉ lưu trữ các sản phẩm duy nhất dựa trên brand, name và color
      final Map<String, Clother> uniqueClothesMap = {};

      for (var doc in querySnapshot.docs) {
        final Clother clother = Clother(
          id: doc['id'],
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

        // Tạo một khóa duy nhất cho Map dựa trên brand, name và color
        final String uniqueKey =
            '${clother.brand}_${clother.name}_${clother.color}';

        // Nếu khóa này chưa tồn tại trong Map thì thêm sản phẩm vào Map
        if (!uniqueClothesMap.containsKey(uniqueKey)) {
          uniqueClothesMap[uniqueKey] = clother;
        }
      }

      // Chuyển đổi Map thành List
      cloShop = uniqueClothesMap.values.toList();
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

  Future<void> clearCart(List<UserCart> items) async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      for (var item in items) {
        userCart.remove(item);

        QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
            .collection('userCart')
            .where('name', isEqualTo: item.productName)
            .where('size', isEqualTo: item.size)
            .where('color', isEqualTo: item.color)
            .where('uid', isEqualTo: uid)
            .get();

        for (var doc in cartSnapshot.docs) {
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

  Future<AddressModel?> fetchUserAddress() async {
    User? currentUser = _authenticationService.getCurrentUser();
    if (currentUser == null) {
      print('User is not logged in');
      return null;
    }
    String uid = currentUser.uid;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('deliveryAddress')
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    return AddressModel.fromMap(
        documentSnapshot.data() as Map<String, dynamic>);
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
        if (item.productName == clother.name &&
            item.size == size &&
            item.color == clother.color) {
          item.quantity += quantity;
          productExists = true;

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
          break;
        }
      }

      if (!productExists) {
        UserCart cartItem = UserCart(
          productName: clother.name,
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
          'name': cartItem.productName,
          'price': cartItem.price,
          'imagePath': cartItem.imagePath,
          'description': cartItem.description,
          'brand': cartItem.brand,
          'color': cartItem.color,
          'size': cartItem.size,
          'quantity': cartItem.quantity,
          'uid': uid,
        });
      }

      notifyListeners();
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> saveDeliveryAddress(
      String address, String name, String phone) async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      await FirebaseFirestore.instance.collection('deliveryAddress').add({
        'address': address,
        'name': name,
        'phone': phone,
        'uid': uid,
      });

      print('Delivery address saved successfully');
    } catch (e) {
      print('Error saving delivery address: $e');
    }
  }

  Future<void> updateDeliveryAddress(
      String address, String name, String phone) async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('deliveryAddress')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('deliveryAddress')
            .doc(docId)
            .update({
          'address': address,
          'name': name,
          'phone': phone,
        });
        print('Delivery address updated successfully');
      } else {
        await saveDeliveryAddress(address, name, phone);
      }
    } catch (e) {
      print('Error updating delivery address: $e');
    }
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
        if (item.productName == clother.productName &&
            item.size == clother.size &&
            item.color == clother.color) {
          if (item.quantity > 1) {
            item.quantity -= 1;

            // Update Firestore quantity
            QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection('userCart')
                .where('name', isEqualTo: clother.productName)
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
                .where('name', isEqualTo: clother.productName)
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
        if (item.productName == clother.productName &&
            item.size == clother.size &&
            item.color == clother.color) {
          item.quantity = quantity;

          // Update Firestore quantity
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection('userCart')
              .where('name', isEqualTo: clother.productName)
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
            .where('name', isEqualTo: item.productName)
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

  double getTotalPrice() {
    double total = 0.0;
    for (var item in userCart) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
