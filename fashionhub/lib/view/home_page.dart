import 'package:fashionhub/components/bottom_nav_bar.dart';
import 'package:fashionhub/components/zalo_component.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/cart_page.dart';
import 'package:fashionhub/view/login_screen.dart';
import 'package:fashionhub/view/search_page.dart';
import 'package:fashionhub/view/shop_page.dart';
import 'package:fashionhub/view/user_profile_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ShopPage(),
    const CartPage(),
    ProfilePage(authService: AuthenticationService()),
  ];

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
      // Xử lý lỗi nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      appBar: _selectedIndex == 1 || _selectedIndex == 2
          ? null
          : AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.05,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    child: const Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 30,
                    ),
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchPage()),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      drawer: Drawer(
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
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Trang chủ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZaloComponent(),
                        )),
                    child: const ListTile(
                      leading: Icon(
                        Icons.help_outline_sharp,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Hổ trợ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
      ),
      body: _pages[_selectedIndex],
    );
  }
}
