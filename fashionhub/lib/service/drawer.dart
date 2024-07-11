import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/login_screen.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'lib/images/logo.png',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: GestureDetector(
              onTap: () => _logout(context), // Call the _logout method here
              child: const ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  try {
    AuthenticationService authenticationService = AuthenticationService();
    await authenticationService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  } catch (e) {
    print('Error logging out: $e');
  }
}
