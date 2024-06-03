import 'package:fashionhub/firebase_options.dart';
import 'package:fashionhub/view/addproduc_screen.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/view/welcome.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/home_screen.dart';
import 'package:fashionhub/view/login_screen.dart';
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: screenproducts(),
      ),
    );
  }
}
