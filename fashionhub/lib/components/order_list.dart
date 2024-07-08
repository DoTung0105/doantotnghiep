import 'package:fashionhub/components/order_item.dart';
import 'package:flutter/material.dart';

class TabItem {
  final String title;
  TabItem({required this.title});
}

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<TabItem> lstOrderTab = [
    TabItem(title: "Chờ xác nhận"),
    TabItem(title: "Đang giao"),
    TabItem(title: "Thành công"),
    TabItem(title: "Đã hủy"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: DefaultTabController(
        length: lstOrderTab.length,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: false,
              tabs: lstOrderTab
                  .map((tabItem) => Tab(text: tabItem.title))
                  .toList(),
              labelPadding:
                  EdgeInsets.symmetric(horizontal: 0.0), // Adjust labelPadding
              labelStyle:
                  TextStyle(fontSize: 14.0), // Adjust labelStyle if necessary
            ),
            centerTitle: true,
            automaticallyImplyLeading: true, // Prevent leading padding
          ),
          body: TabBarView(
            children: lstOrderTab.map((tabItem) {
              return OrderItem(status: tabItem.title);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
