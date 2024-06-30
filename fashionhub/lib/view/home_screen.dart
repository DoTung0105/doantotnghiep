import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/service/drawer.dart';
import 'package:fashionhub/view/addproduc_screen.dart';
import 'package:fashionhub/view/admin_user_order.dart';
import 'package:fashionhub/view/changepassword_screen.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/view/login_screen.dart';

import 'package:fashionhub/view/user_profile_screen.dart';
import 'package:fashionhub/view/users_screen.dart';
import 'package:fashionhub/view/voucher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  await _logout(context);
                },
                icon: Icon(Icons.logout))
          ],
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
        backgroundColor: Colors.white,
        drawer: DrawerMenu(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'add product',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => screenproducts()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'list products',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(authService: AuthenticationService())),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => users_Screen()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'user',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(
                          authService: AuthenticationService())),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'Changepassword',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Voucher_Screen()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'Voucher',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Orders_Screen()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'order',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

Future<void> _logout(BuildContext context) async {
  try {
    AuthenticationService authenticationService = AuthenticationService();
    await authenticationService.signOut();
    // Đăng xuất thành công, điều hướng đến màn hình đăng nhập hoặc trang chính
    // ở đây là ví dụ chuyển về màn hình đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  } catch (e) {
    print('Error logging out: $e');
    // Xử lý lỗi nếu cần
  }
}
