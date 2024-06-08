import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/addproduc_screen.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/view/user_profile_screen.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Add product'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductPage(),
                  ));
            },
          ),
          ListTile(
            title: const Text('List product'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screenproducts(),
                  ));
            },
          ),
          ListTile(
            title: const Text('User profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(authService: AuthenticationService()),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
