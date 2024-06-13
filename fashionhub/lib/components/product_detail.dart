import 'package:fashionhub/model/cart.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:fashionhub/view/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  final Clother product;
  final int quantityCount;
  final VoidCallback incrementQuantity;
  final VoidCallback decrementQuantity;
  final String selectedSize;
  final Function(String) selectSize;

  const ProductDetails({
    Key? key,
    required this.product,
    required this.quantityCount,
    required this.incrementQuantity,
    required this.decrementQuantity,
    required this.selectedSize,
    required this.selectSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double price = double.parse(product.price);
    double totalPrice = price * quantityCount;
    final formattedTotalPrice = NumberFormat("#,###", "vi").format(totalPrice);
    final formatter = NumberFormat('#,###', 'vi_VN');
    String formattedPrice =
        formatter.format(double.parse(product.price.replaceAll('.', '')));

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 8),
      color: Color.fromARGB(211, 189, 189, 189),
      child: Column(
        children: [
          // Price - Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₫$formattedPrice',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 140,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: decrementQuantity,
                      ),
                    ),
                    Text(
                      quantityCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: incrementQuantity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Size Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kích thước:',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Row(
                children: ['M', 'L', 'XL'].map((size) {
                  return GestureDetector(
                    onTap: () => selectSize(size),
                    child: Container(
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      //padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedSize == size
                              ? Colors.black
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            size,
                            style: TextStyle(
                              color: selectedSize == size
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Add to Cart Button
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 5,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 38, 171, 154),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .addItemToCart(product, quantityCount, selectedSize);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sản phẩm đã được thêm vào giỏ hàng'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            'Thêm vào giỏ hàng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 77, 45),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Mua ngay',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '₫$formattedTotalPrice',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
