import 'package:fashionhub/view/list_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';

class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Color.fromARGB(255, 39, 176, 112),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: viewModel.setDescription,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
//
                decoration: InputDecoration(
                  labelText: 'Price',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                //
                keyboardType: TextInputType.number,
                onChanged: viewModel.setPrice,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Size',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: viewModel.setSize,
              ),
              SizedBox(height: 20),
              viewModel.image == null
                  ? Text('No image selected.')
                  : Image.file(viewModel.image!),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 30)),
                onPressed: viewModel.pickImage,
                child: Text(
                  'Pick Image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 30)),
                onPressed: () async {
                  try {
                    await viewModel.addProduct();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Product added successfully')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screenproducts()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add product: $e')),
                    );
                  }
                },
                child: Text(
                  'Add Product',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
