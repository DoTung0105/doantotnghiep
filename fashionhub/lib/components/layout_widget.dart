import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Widget giao diện brand của filter_option
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

// Widget định dạng hiển thị giá tiền V1
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

// Widget định dạng hiển thị giá tiền V2
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

// Widget xử lý TextField Tối thiểu - Tối đa không được âm của filter_option
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

// Widget cho các thông tin của User_profile_screen
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;

  ProfileItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.deepPurpleAccent,
            size: 28,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget điều chỉnh viền Container của User_profile_screen
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 100);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Widget xử lý Tab của Order_List
class TabItem {
  TabItem({this.title = "", this.active = false});
  String title;
  bool active;

  static List<TabItem> lstTab =
      List.filled(0, TabItem(title: ""), growable: true);
}
