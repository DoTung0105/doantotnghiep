import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final Clother product;
  final int quantityCount;
  final VoidCallback incrementQuantity;
  final VoidCallback decrementQuantity;
  final String selectedSize;
  final Function(String) selectSize;
  final VoidCallback addToCart;
  final VoidCallback buyNow; // Thêm thuộc tính này

  const ProductDetails({
    Key? key,
    required this.product,
    required this.quantityCount,
    required this.incrementQuantity,
    required this.decrementQuantity,
    required this.selectedSize,
    required this.selectSize,
    required this.addToCart,
    required this.buyNow, // Khởi tạo thuộc tính này
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double price = product.price;
    double totalPrice = price * quantityCount;

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 8),
      color: Color.fromARGB(211, 189, 189, 189),
      child: Column(
        children: [
          // Price - Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriceWidget(
                price: product.price,
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
                    onPressed:
                        addToCart, // Gọi addToCart khi người dùng nhấn nút
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
                    onTap: buyNow, // Gọi buyNow khi người dùng nhấn nút

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
                        PriceWidget(
                          price: totalPrice,
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
