import 'package:fashionhub/components/product_detail.dart';
import 'package:fashionhub/model/cart.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final Clother detailCol;
  const DetailPage({super.key, required this.detailCol});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantityCount = 1;
  String selectedSize = 'M';

  // Phương thức giảm số lượng
  void decrementQuantity() {
    if (quantityCount > 1) {
      setState(() {
        quantityCount--;
      });
    }
  }

  // Phương thức tăng số lượng
  void incrementQuantity() {
    setState(() {
      if (quantityCount < widget.detailCol.wareHouse) {
        quantityCount++;
      }
    });
  }

  void selectSize(String size) {
    setState(() {
      selectedSize = size;
    });
  }

  void addToCart() {
    Provider.of<Cart>(context, listen: false).addItemToCart(
      widget.detailCol,
      quantityCount,
      selectedSize, // Chuyển kích thước đã chọn vào hàm addItemToCart
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sản phẩm đã được thêm vào giỏ hàng'),
        duration: Duration(seconds: 2),
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView(
                children: [
                  // Image
                  Image.asset(
                    widget.detailCol.imagePath,
                    height: 300,
                  ),
                  const SizedBox(height: 10),

                  // Evalute
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
                              widget.detailCol.evaluate.toString(),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        'Kho:' + widget.detailCol.wareHouse.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Name
                  Text(
                    widget.detailCol.name,
                    style: const TextStyle(fontSize: 25, color: Colors.black),
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

                  Text('• Thương hiệu: ' + widget.detailCol.brand),
                  Text('• Màu: ' + widget.detailCol.color),
                  const SizedBox(height: 10),

                  Text(
                    widget.detailCol.description,
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
            product: widget.detailCol,
            quantityCount: quantityCount,
            incrementQuantity: incrementQuantity,
            decrementQuantity: decrementQuantity,
            selectedSize: selectedSize,
            selectSize: selectSize,
          ),
        ],
      ),
    );
  }
}
