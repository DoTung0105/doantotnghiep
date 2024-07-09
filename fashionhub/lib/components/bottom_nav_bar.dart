import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade700,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home_outlined,
            text: ' Trang chủ',
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 21),
          ),
          GButton(
            icon: Icons.shopping_bag_outlined,
            text: ' Giỏ hàng',
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 21),
          ),
          GButton(
            icon: Icons.account_circle_outlined,
            text: ' Cá nhân',
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 21),
          ),
        ],
      ),
    );
  }
}
