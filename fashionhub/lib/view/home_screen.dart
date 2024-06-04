import 'package:fashionhub/view/addproduc_screen.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/view/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.abc),
        actions: [IconButton(onPressed: () {
          //thoat dang nhap tai khoan moi
        }, icon: Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          Center(
            child: Text('Welcome to Home Screen!'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
              child: Icon(Icons.abc)),
               ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screenproducts()),
                );
              },
              child: Icon(Icons.abc))
        ],
      ),
    );
  }
}
