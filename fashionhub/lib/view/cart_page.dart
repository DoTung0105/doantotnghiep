import 'package:fashionhub/components/cart_item.dart';
import 'package:fashionhub/model/cart.dart';
import 'package:fashionhub/model/userCart.dart';
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
  List<UserCart> selectedItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Cart>(context, listen: false).fetchClotherList();
      Provider.of<Cart>(context, listen: false).fetchUserCart();
    });
  }

  void onItemCheckedChange(bool? isChecked, UserCart cartItem) {
    setState(() {
      if (isChecked == true) {
        selectedItems.add(cartItem);
      } else {
        selectedItems.remove(cartItem);
      }
    });
  }

  void onSelectAllCheckedChange(bool? isChecked, List<UserCart> cartItems) {
    setState(() {
      if (isChecked == true) {
        selectedItems = List.from(cartItems);
      } else {
        for (var item in cartItems) {
          selectedItems.remove(item);
        }
      }
    });
  }

  Future<void> removeSelectedItems() async {
    bool confirmed = await showDialog(
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
                  const Text(
                    'Xác nhận',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              content: const Text(
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
                        child: const Text('Hủy'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
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
                        child: const Text('Xóa'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmed) {
      await Provider.of<Cart>(context, listen: false)
          .removeItems(selectedItems);
      setState(() {
        selectedItems.clear();
      });
    }
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
    var cartItems = Provider.of<Cart>(context).getUserCart();

    bool allItemsSelected =
        cartItems.isNotEmpty && selectedItems.length == cartItems.length;

    // Group cart items by brand
    Map<String, List<UserCart>> groupedItems = {};
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/images/cart.png'),
                  const Text(
                    'Giỏ hàng hiện đang trống',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ],
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
                      List<UserCart> items = groupedItems[brand]!;
                      bool allItemsInGroupSelected =
                          items.every((item) => selectedItems.contains(item));
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
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
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: allItemsInGroupSelected,
                                    onChanged: (isChecked) {
                                      onSelectAllCheckedChange(
                                          isChecked, items);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    brand,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
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
                                cartItem: item,
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
                const Divider(),
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
