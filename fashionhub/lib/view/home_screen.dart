import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/service/drawer.dart';
import 'package:fashionhub/view/addproduc_screen.dart';
import 'package:fashionhub/view/changepassword_screen.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/view/login_screen.dart';

import 'package:fashionhub/view/user_profile_screen.dart';
import 'package:fashionhub/view/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
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
        drawer: DrawerMenu(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductPage()),
                  );
                },
                child: Text("Add products"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screenproducts()),
                  );
                },
                child: Text("List products"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        authService: AuthenticationService(),
                      ),
                    ),
                  );
                },
                child: Text("User profile"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => users_Screen()),
                  );
                },
                child: Text("Users"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(
                            authService: AuthenticationService())),
                  );
                },
                child: Text("Change Password"),
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
      MaterialPageRoute(
          builder: (context) =>
              LoginScreen()), // Thay `LoginScreen()` bằng màn hình cụ thể bạn muốn chuyển hướng tới
    );
  } catch (e) {
    print('Error logging out: $e');
    // Xử lý lỗi nếu cần
  }
}
