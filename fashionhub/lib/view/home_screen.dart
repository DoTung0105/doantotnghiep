import 'package:fashionhub/service/drawer.dart';
import 'package:fashionhub/view/addproduc_screen.dart';
import 'package:fashionhub/view/admin_user_order.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/view/statistics_screen.dart';
import 'package:fashionhub/view/users_screen.dart';
import 'package:fashionhub/view/voucher_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          'FashionHub',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            icon: Icon(
              isGridView ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
              size: 40,
            ),
          ),
        ],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: DrawerMenu(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedCrossFade(
            duration: Duration(milliseconds: 500),
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeInOut,
            crossFadeState: isGridView
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildGridItem(
                    context, 'Add Product', AddProductPage(), Icons.add_box),
                _buildGridItem(
                    context, 'List Products', screenproducts(), Icons.list),
                _buildGridItem(context, 'Users', users_Screen(), Icons.group),
                _buildGridItem(
                    context, 'Voucher', Voucher_Screen(), Icons.card_giftcard),
                _buildGridItem(
                    context, 'Orders', Orders_Screen(), Icons.shopping_cart),
                _buildGridItem(context, 'Statistics', Statistics_Screen(),
                    Icons.bar_chart),
              ],
            ),
            secondChild: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildListItem(
                    context, 'Add Product', AddProductPage(), Icons.add_box),
                _buildListItem(
                    context, 'List Products', screenproducts(), Icons.list),
                _buildListItem(context, 'Users', users_Screen(), Icons.group),
                _buildListItem(
                    context, 'Voucher', Voucher_Screen(), Icons.card_giftcard),
                _buildListItem(
                    context, 'Orders', Orders_Screen(), Icons.shopping_cart),
                _buildListItem(context, 'Statistics', Statistics_Screen(),
                    Icons.bar_chart),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String title, Widget page, IconData icon) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        shadowColor: Colors.black54,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, String title, Widget page, IconData icon) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => page),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        shadowColor: Colors.black54,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
