import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/service/drawer.dart';
import 'package:fashionhub/view/addproduc_screen.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/view/login_screen.dart';
import 'package:fashionhub/view/user_profile_screen.dart';
import 'package:fashionhub/view/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: DrawerMenu(),
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
              child: Text("Add products")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screenproducts()),
                );
              },
              child: Text("List products")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(authService: AuthenticationService())),
                );
              },
              child: Text("User profile")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => users_Screen()),
                );
              },
              child: Text("Users"))
        ],
      ),
    );
  }
}
