import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  List<Clother> cloShop = [];
  List<Clother> userCart = [];

  // Constructor
  Cart() {
    fetchClotherList();
  }

  // Fetch data from Firestore
  Future<void> fetchClotherList() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      final List<Clother> fetchedClothes = querySnapshot.docs.map((doc) {
        return Clother(
          name: doc['name'],
          price: doc['price'].toString(),
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
      notifyListeners(); // Notify listeners when data is loaded
    } catch (e) {
      print('Error fetching clothes: $e');
    }
  }

  List<Clother> getClotherList() {
    return cloShop;
  }

  List<Clother> getUserCart() {
    return userCart;
  }

  List<String> getBranchesList() {
    Set<String> brandesSet = {};
    for (var item in cloShop) {
      brandesSet.add(item.brand);
    }
    return brandesSet.toList();
  }

  void addItemToCart(Clother clother, int quantity, String size) {
    bool productExists = false;
    for (var item in userCart) {
      if (item.name == clother.name && item.size == size) {
        item.quantity += quantity;
        productExists = true;
        break;
      }
    }
    if (!productExists) {
      Clother cartItem = Clother(
        name: clother.name,
        price: clother.price,
        imagePath: clother.imagePath,
        description: clother.description,
        brand: clother.brand,
        color: clother.color,
        size: size,
        evaluate: clother.evaluate,
        sold: clother.sold,
        wareHouse: clother.wareHouse,
        quantity: quantity,
      );
      userCart.add(cartItem);
    }
    notifyListeners();
  }

  List<Clother> sortClotherList(String sortOption) {
    List<Clother> sortedList = List.from(cloShop);
    switch (sortOption) {
      case 'Giá từ thấp đến cao':
        sortedList.sort((a, b) => double.parse(a.price.replaceAll('.', ''))
            .compareTo(double.parse(b.price.replaceAll('.', ''))));
        break;
      case 'Giá từ cao đến thấp':
        sortedList.sort((a, b) => double.parse(b.price.replaceAll('.', ''))
            .compareTo(double.parse(a.price.replaceAll('.', ''))));
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

  void removeItemFromCart(Clother clother) {
    for (var item in userCart) {
      if (item.name == clother.name) {
        if (item.quantity > 1) {
          item.quantity -= 1;
        } else {
          userCart.remove(item);
        }
        notifyListeners();
        return;
      }
    }
  }

  void removeItems(List<Clother> items) {
    for (var item in items) {
      userCart.remove(item);
    }
    notifyListeners();
  }
}
