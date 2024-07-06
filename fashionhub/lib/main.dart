import 'package:fashionhub/firebase_options.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/home_screen.dart';
import 'package:fashionhub/view/intro_page.dart';
import 'package:fashionhub/view/login_screen.dart';
import 'package:fashionhub/viewmodel/cart_viewmodel.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:fashionhub/viewmodel/user_order_viewmodel.dart';
import 'package:fashionhub/viewmodel/voucher_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductViewModel()),
          ChangeNotifierProvider(
            create: (_) => Cart(AuthenticationService()),
          ),
          ChangeNotifierProvider(create: (_) => VoucherViewModel()),
          ChangeNotifierProvider(create: (_) => User_Order_ViewModel())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<bool>(
            future: AuthenticationService().isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData && snapshot.data == true) {
                  // Lấy uid của người dùng hiện tại
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String uid = user.uid;

                    return FutureBuilder<String?>(
                      future: AuthenticationService().getUserRole(uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData) {
                            String? role = snapshot.data;
                            if (role == 'Admin') {
                              return HomeScreen(); // Trang của admin
                            } else {
                              return IntroPage(); // Trang của người dùng
                            }
                          } else {
                            // Xử lý khi role là null
                            return IntroPage(); // Hoặc trang mặc định khác
                          }
                        }
                      },
                    );
                  } else {
                    return LoginScreen(); // Xử lý khi user là null
                  }
                } else {
                  return LoginScreen(); // Xử lý khi không có dữ liệu đăng nhập
                }
              }
            },
          ),
        ));
  }
}
