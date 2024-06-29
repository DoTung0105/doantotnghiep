import 'package:fashionhub/firebase_options.dart';
import 'package:fashionhub/model/cart.dart';

import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/admin_order.dart';
import 'package:fashionhub/view/changepassword_screen.dart';
import 'package:fashionhub/view/forgotpass_screen.dart';

import 'package:fashionhub/view/login_screen.dart';
import 'package:fashionhub/view/voucher_screen.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:fashionhub/viewmodel/voucher_viewmodel.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
