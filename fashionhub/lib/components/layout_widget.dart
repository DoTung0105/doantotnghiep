import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BranchRangeContainer extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const BranchRangeContainer({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _BranchRangeContainerState createState() => _BranchRangeContainerState();
}

class _BranchRangeContainerState extends State<BranchRangeContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 170,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: widget.isSelected
              ? Border.all(
                  color: Color.fromARGB(235, 235, 85, 20),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Format Price
class PriceWidget extends StatelessWidget {
  final double price;
  final TextStyle? style;

  const PriceWidget({
    Key? key,
    required this.price,
    this.style,
  }) : super(key: key);

  String formatPrice(double price) {
    NumberFormat formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(price).trim();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '₫${formatPrice(price)}',
      style: style ?? TextStyle(color: Colors.red, fontSize: 20),
    );
  }
}

class PriceWidgetII extends StatelessWidget {
  final double price;
  final TextStyle? style;

  const PriceWidgetII({
    Key? key,
    required this.price,
    this.style,
  }) : super(key: key);

  String formatPriceII(double price) {
    NumberFormat formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(price).trim();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${formatPriceII(price)}₫',
      style: style ?? TextStyle(color: Colors.black, fontSize: 14),
    );
  }
}

class NonNegativeIntFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final intValue = int.tryParse(newValue.text);
    if (intValue == null || intValue < 0) {
      return oldValue;
    }

    return newValue;
  }
}
