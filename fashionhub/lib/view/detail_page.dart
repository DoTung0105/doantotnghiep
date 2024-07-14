import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/components/product_detail.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:fashionhub/model/userCart_model.dart';
import 'package:fashionhub/view/checkout_page.dart';
import 'package:fashionhub/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final Clother detailCol;

  const DetailPage({Key? key, required this.detailCol}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantityCount = 1;
  String selectedSize = 'M';
  int wareHouse = 0;

  @override
  void initState() {
    super.initState();
    fetchWareHouse(selectedSize);
  }

  Future<void> fetchWareHouse(String size) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: widget.detailCol.name)
          .where('brand', isEqualTo: widget.detailCol.brand)
          .where('color', isEqualTo: widget.detailCol.color)
          .where('size', isEqualTo: size)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        wareHouse = querySnapshot.docs.first['wareHouse'];
        setState(() {});
      }
    } catch (e) {
      print('Error fetching wareHouse: $e');
    }
  }

  void decrementQuantity() {
    if (quantityCount > 1) {
      setState(() {
        quantityCount--;
      });
    }
  }

  void incrementQuantity() {
    setState(() {
      if (quantityCount < wareHouse) {
        quantityCount++;
      }
    });
  }

  void selectSize(String size) {
    setState(() {
      selectedSize = size;
      fetchWareHouse(
          selectedSize); // Cập nhật số lượng wareHouse khi size thay đổi
    });
  }

  void addToCart() {
    Provider.of<Cart>(context, listen: false).addItemToCart(
      widget.detailCol,
      quantityCount,
      selectedSize,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sản phẩm đã được thêm vào giỏ hàng'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void buyNow() {
    List<UserCart> selectedItems = [
      UserCart(
        productName: widget.detailCol.name,
        price: widget.detailCol.price,
        imagePath: widget.detailCol.imagePath,
        description: widget.detailCol.description,
        brand: widget.detailCol.brand,
        color: widget.detailCol.color,
        size: selectedSize,
        uid: '',
        evaluate: widget.detailCol.evaluate,
        sold: widget.detailCol.sold,
        wareHouse: widget.detailCol.wareHouse,
        quantity: quantityCount,
      ),
    ];

    double totalPayment = selectedItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOutPage(
          selectedItems: selectedItems,
          totalPayment: totalPayment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: widget.detailCol,
        child: Consumer<Clother>(
          builder: (context, clother, child) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView(
                      children: [
                        // Image
                        Image.network(
                          clother.imagePath,
                          height: 300,
                        ),
                        const SizedBox(height: 10),

                        // Evaluate
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(124, 223, 205, 198),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow[800],
                                    size: 14,
                                  ),
                                  Text(
                                    clother.evaluate.toString(),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            wareHouse != 0
                                ? Text(
                                    'Kho: $wareHouse',
                                  )
                                : Text('Kho: Hết hàng')
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Name
                        Text(
                          clother.name,
                          style: const TextStyle(
                              fontSize: 25, color: Colors.black),
                        ),
                        const SizedBox(height: 25),

                        // Description
                        Text(
                          'Thông tin sản phẩm',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 5),

                        Text('• Thương hiệu: ${clother.brand}'),
                        Text('• Màu: ${clother.color}'),
                        const SizedBox(height: 10),

                        Text(
                          clother.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Price - Quantity - Add to Cart - Size Selection
                ProductDetails(
                  product: clother,
                  quantityCount: quantityCount,
                  incrementQuantity: incrementQuantity,
                  decrementQuantity: decrementQuantity,
                  selectedSize: selectedSize,
                  selectSize: selectSize,
                  wareHouse: wareHouse,
                  addToCart: addToCart,
                  buyNow: buyNow,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
