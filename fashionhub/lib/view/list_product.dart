import 'dart:io';

import 'package:fashionhub/model/products.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền của container
                    borderRadius: BorderRadius.circular(12.0), // Bo góc
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Màu bóng mờ
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Vị trí của bóng
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hình ảnh nằm bên trái
                      SizedBox(
                        width: 100,
                        child: Image.network(
                          products[index].imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(width: 10),
                      // Thông tin sản phẩm nằm bên phải
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name : ${products[index].name}'),
                            Text('Price : ${products[index].price}'),
                            Text(
                                'Description : ${products[index].description}'),
                            Text('Size : ${products[index].size}'),
                            Text('Color : ${products[index].color}'),
                            Text('Branch : ${products[index].brand}'),
                            Text('Sold : ${products[index].sold}'),
                            Text('Warehouse : ${products[index].wareHouse}')
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Delete Product'),
                                    content: Text(
                                        'Are you sure you want to delete this product?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<ProductViewModel>(context,
                                                  listen: false)
                                              .deleteProduct(
                                                  products[index].id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text("Del")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProductPage(
                                            product: products[index])));
                              },
                              child: Text('Edit'))
                        ],
                      ),
                    ],
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

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  // late TextEditingController _sizeController;
  late TextEditingController _branchController;
  late TextEditingController _nameController;
  late TextEditingController _soldController;
  late TextEditingController _warehouseController;
  late TextEditingController _colorController;
  String? _setSize;
  // String? _selectedColor;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  ProductViewModel viewModel = ProductViewModel();

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    //  _sizeController = TextEditingController(text: widget.product.size);

    _branchController = TextEditingController(text: widget.product.brand);
    _nameController = TextEditingController(text: widget.product.name);
    _soldController = TextEditingController(
        text: widget.product.sold
            .toString()); // 11.6 - Thịnh sửa lại kiểu dl cho sold
    _warehouseController = TextEditingController(
        text: widget.product.wareHouse
            .toString()); // 11.6 - Thịnh sửa lại kiểu dl cho wareHouse
    _colorController = TextEditingController(text: widget.product.color);
    //  _selectedColor = widget.product.color;
    _setSize = widget.product.size;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    // _sizeController.dispose();
    _branchController.dispose();
    _nameController.dispose();
    _soldController.dispose();
    _warehouseController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // 13.6 - Thịnh đổi camera thành gallery

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Product'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile != null
                      ? Image.file(_imageFile!)
                      : Image.network(widget.product.imagePath),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                // TextField(
                //   controller: _sizeController,
                //   decoration: InputDecoration(labelText: 'Size'),
                // ),
                DropdownButtonFormField<String>(
                  value: _setSize,
                  items: viewModel.sizeoption
                      .map((color) => DropdownMenuItem<String>(
                            value: color,
                            child: Text(color),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _setSize = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Size'),
                ),
                TextField(
                  controller: _branchController,
                  decoration: InputDecoration(labelText: 'Branch'),
                ),
                // DropdownButtonFormField<String>(
                //   value: _selectedColor,
                //   items: viewModel.coloroption
                //       .map((color) => DropdownMenuItem<String>(
                //             value: color,
                //             child: Text(color),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedColor = value!;
                //     });
                //   },
                //   decoration: InputDecoration(labelText: 'Color'),
                // ),
                TextField(
                  controller: _colorController,
                  decoration: InputDecoration(labelText: 'Color'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _soldController,
                  decoration: InputDecoration(labelText: 'Sold'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _warehouseController,
                  decoration: InputDecoration(labelText: 'warehouse'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    String imagePath = widget.product.imagePath;
                    if (_imageFile != null) {
                      imagePath = await viewModel.uploadImage(_imageFile!);
                    }
                    Product updatedProduct = Product(
                      id: widget.product.id,
                      imagePath: imagePath,
                      description: _descriptionController.text,
                      price: double.parse(_priceController.text),
                      size: _setSize!,
                      brand: _branchController.text,
                      color: _colorController.text,
                      name: _nameController.text,
                      sold: int.parse(_soldController
                          .text), // 11.6 - Thịnh sửa lại kiểu dl cho sold
                      wareHouse: int.parse(_warehouseController
                          .text), // 11.6 - Thịnh sửa lại kiểu dl cho wareHouse
                    );
                    await viewModel.updateProduct(updatedProduct);
                    Navigator.pop(context);
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
