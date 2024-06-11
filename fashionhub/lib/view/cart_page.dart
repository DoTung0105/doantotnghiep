import 'package:fashionhub/components/cart_item.dart';
import 'package:fashionhub/model/cart.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:fashionhub/view/payment_page.dart';
import 'package:fashionhub/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Clother> selectedItems = [];

  void onItemCheckedChange(bool? isChecked, Clother clother) {
    setState(() {
      if (isChecked == true) {
        selectedItems.add(clother);
      } else {
        selectedItems.remove(clother);
      }
    });
  }

  void onSelectAllCheckedChange(bool? isChecked, List<Clother> cartItems) {
    setState(() {
      if (isChecked == true) {
        selectedItems = List.from(cartItems);
      } else {
        selectedItems.clear();
      }
    });
  }

  void removeSelectedItems() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.yellow[700],
              ),
              const SizedBox(width: 5),
              Text(
                'Xác nhận',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa?',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 113,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 222, 217, 217),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                    child: Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  width: 113,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 211, 117, 116),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                    child: Text('Xóa'),
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .removeItems(selectedItems);
                      setState(() {
                        selectedItems.clear();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void navToPaymentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(),
      ),
    );
  }

  void navToSearchPage(String brand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(initialSearchQuery: brand),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cartItems = Provider.of<Cart>(context, listen: true).getUserCart();

    bool allItemsSelected =
        cartItems.isNotEmpty && selectedItems.length == cartItems.length;

    // Group cart items by brand
    Map<String, List<Clother>> groupedItems = {};
    for (var item in cartItems) {
      if (groupedItems.containsKey(item.brand)) {
        groupedItems[item.brand]!.add(item);
      } else {
        groupedItems[item.brand] = [item];
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Consumer<Cart>(
          builder: (context, cart, child) {
            int itemCount = cart.getUserCart().length;
            return Text(
              'Giỏ hàng (${itemCount})',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color:
                  selectedItems.isNotEmpty ? Colors.black : Colors.transparent,
            ),
            onPressed: selectedItems.isNotEmpty ? removeSelectedItems : null,
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, value, child) {
          if (value.getUserCart().isEmpty) {
            return Center(
              child: Text(
                'Không có sản phẩm',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedItems.length,
                    itemBuilder: (context, index) {
                      String brand = groupedItems.keys.elementAt(index);
                      List<Clother> items = groupedItems[brand]!;
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 230, 222, 222)),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: selectedItems
                                        .toSet()
                                        .containsAll(items),
                                    onChanged: (isChecked) {
                                      onSelectAllCheckedChange(
                                          isChecked, items);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    brand,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14.5,
                                    ),
                                    onPressed: () {
                                      navToSearchPage(brand);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ...items.map((item) {
                              return CartItem(
                                clother: item,
                                isChecked: selectedItems.contains(item),
                                onCheckboxChanged: (isChecked) =>
                                    onItemCheckedChange(isChecked, item),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                PaymentSection(
                  selectedItems: selectedItems,
                  allItemsSelected: allItemsSelected,
                  onSelectAllCheckedChange: (isChecked) =>
                      onSelectAllCheckedChange(isChecked, cartItems),
                  onPayment: navToPaymentPage,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
