import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:fashionhub/model/products.dart';

class ListProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: Provider.of<ProductViewModel>(context).getProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Product>? products = snapshot.data;
          if (products != null && products.isNotEmpty) {
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width / 4,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          maxRadius: Checkbox.width /
                              1, // Increase the maxRadius value
                          child: Image.network(products[index].imageUrl),
                        ),
                        SizedBox(height: 8.0),
                        Text('Description: ${products[index].description}'),
                        Text('Price: ${products[index].price}'),
                        Text('Size: ${products[index].size}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Text('No products available');
          }
        }
      },
    );
  }
}

class screenproducts extends StatefulWidget {
  const screenproducts({super.key});

  @override
  State<screenproducts> createState() => _screenproductsState();
}

class _screenproductsState extends State<screenproducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListProductPage(),
    );
  }
}
