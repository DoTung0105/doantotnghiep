import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/model/userCart_model.dart';
import 'package:fashionhub/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final UserCart cartItem;
  final ValueChanged<bool?> onCheckboxChanged;
  final bool isChecked;

  CartItem({
    super.key,
    required this.cartItem,
    required this.onCheckboxChanged,
    required this.isChecked,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(CartItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked) {
      if (widget.isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void incrementQuantity() {
    setState(() {
      widget.cartItem.quantity++;
    });
    Provider.of<Cart>(context, listen: false)
        .updateItemQuantity(widget.cartItem, widget.cartItem.quantity);
  }

  void decrementQuantity() {
    setState(() {
      if (widget.cartItem.quantity > 1) {
        widget.cartItem.quantity--;
      }
    });
    Provider.of<Cart>(context, listen: false)
        .updateItemQuantity(widget.cartItem, widget.cartItem.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                shape: CircleBorder(),
                value: widget.isChecked,
                onChanged: widget.onCheckboxChanged,
                activeColor: Colors.grey[700],
                checkColor: Colors.white,
              ),
              Expanded(
                child: ListTile(
                  leading: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final isUnderHalfway = _animation.value < 0.5;
                      final displayImage = isUnderHalfway
                          ? widget.cartItem.imagePath
                          : 'https://cdn-icons-png.flaticon.com/512/14026/14026656.png';
                      final image = Image.network(displayImage);
                      return Transform(
                        transform:
                            Matrix4.rotationY(_animation.value * 3.14159),
                        alignment: Alignment.center,
                        child: isUnderHalfway
                            ? image
                            : Transform(
                                transform: Matrix4.rotationY(3.14159),
                                alignment: Alignment.center,
                                child: image,
                              ),
                      );
                    },
                  ),
                  title: Text(
                    widget.cartItem.productName.length <= 50
                        ? widget.cartItem.productName
                        : widget.cartItem.productName.substring(0, 50) + '...',
                    style: TextStyle(fontSize: 17),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.cartItem.color}, ${widget.cartItem.size}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceWidget(
                            price: widget.cartItem.price,
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.grey[700],
                                  size: 14,
                                ),
                                onPressed: decrementQuantity,
                              ),
                              Text(
                                '${widget.cartItem.quantity}',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.grey[700],
                                  size: 14,
                                ),
                                onPressed: incrementQuantity,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget of Payment Container in CartPage
class PaymentSection extends StatelessWidget {
  final List<UserCart> selectedItems;
  final bool allItemsSelected;
  final ValueChanged<bool?> onSelectAllCheckedChange;
  final VoidCallback onPayment;

  PaymentSection({
    required this.selectedItems,
    required this.allItemsSelected,
    required this.onSelectAllCheckedChange,
    required this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    bool anyItemSelected = selectedItems.isNotEmpty;

    // Calculate total price of selected items
    double totalPrice = selectedItems.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    // Format total price
    var formatter = NumberFormat('#,##0', 'vi_VN');
    String formattedTotalPrice = formatter.format(totalPrice);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                shape: CircleBorder(),
                value: allItemsSelected,
                onChanged: onSelectAllCheckedChange,
                activeColor: Colors.grey[700],
                checkColor: Colors.white,
              ),
              Text(
                allItemsSelected ? 'Bỏ chọn\n tất cả' : 'Chọn tất\n cả',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Tổng:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₫$formattedTotalPrice',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(width: 3),
          ElevatedButton(
            onPressed: anyItemSelected ? onPayment : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              backgroundColor: anyItemSelected ? Colors.red : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Thanh toán',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '(${selectedItems.length})',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
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
