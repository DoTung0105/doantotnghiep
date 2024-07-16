import 'dart:io';

import 'package:fashionhub/model/products.dart';
import 'package:fashionhub/view/signup_screen.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListProductPage extends StatefulWidget {
  @override
  _ListProductPageState createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return FutureBuilder<List<Product>>(
            future: productViewModel.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Product>? products = snapshot.data;
                if (products != null && products.isNotEmpty) {
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductItem(product: products[index]);
                    },
                  );
                } else {
                  return Center(child: Text('No products available'));
                }
              }
            },
          );
        },
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                width: 100,
                child: Image.network(
                  widget.product.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.warning_rounded),
                                Text(' Cảnh báo')
                              ],
                            ),
                            content: Text(
                              'Bạn có chắc chắn muốn xóa sản phẩm khỏi cửa hàng?',
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Đóng'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<ProductViewModel>(context,
                                          listen: false)
                                      .deleteProduct(widget.product.id);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text("Xóa"),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProductPage(product: widget.product)));
                      },
                      child: Text('Sửa'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên: ${widget.product.name}'),
                Text(
                    'Giá: ${NumberFormat('#,###').format(widget.product.price)}'),
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 100),
                  firstChild: Text(
                    'Mô tả: ${_truncateDescription(widget.product.description, 40)}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondChild: Text('Mô tả: ${widget.product.description}'),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
                if (widget.product.description.split(' ').length > 40)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? 'Thu gọn' : 'Xem thêm',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Size: ${widget.product.size}')),
                    Expanded(child: Text('Màu: ${widget.product.color}')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Brand: ${widget.product.brand}')),
                    Expanded(
                        child: Text('Đánh giá: ${widget.product.evaluate}')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text('Số lượt bán: ${widget.product.sold}')),
                    Expanded(child: Text('Kho: ${widget.product.wareHouse}')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _truncateDescription(String description, int wordLimit) {
    List<String> words = description.split(' ');
    if (words.length > wordLimit) {
      return words.sublist(0, wordLimit).join(' ') + '...';
    }
    return description;
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
  late TextEditingController _evaluateController;
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.product.description);

    _priceController = TextEditingController(
        text: NumberFormat('#,###').format(widget.product.price));
    //  _sizeController = TextEditingController(text: widget.product.size);
    _evaluateController =
        TextEditingController(text: widget.product.evaluate.toString());
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
    _evaluateController.dispose();
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

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập đầy đủ thông tin';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('Chỉnh sửa sản phẩm'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    controller: _descriptionController,
                    inputFormatters: [NoLeadingSpacesFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
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
                          color: Colors.black, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Giá',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(
                      //     color: Colors.black, // Default border color
                      //   ),
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) {
                          // Định dạng lại giá trị để có dấu phân cách hàng nghìn
                          final formatter = NumberFormat('#,###', 'en_US');
                          if (newValue.text.isEmpty) {
                            return TextEditingValue
                                .empty; // Trường hợp nhập rỗng
                          }
                          final newString =
                              formatter.format(int.parse(newValue.text));
                          return TextEditingValue(
                            text: newString,
                            selection: TextSelection.collapsed(
                                offset: newString.length),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _branchController,
                    inputFormatters: [NoLeadingSpacesFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Thương hiệu',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
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
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _colorController,
                    inputFormatters: [NoLeadingSpacesFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Màu sắc',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    inputFormatters: [NoLeadingSpacesFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Tên sản phẩm',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _soldController,
                    decoration: InputDecoration(
                      labelText: 'Lượt bán',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _warehouseController,
                    decoration: InputDecoration(
                      labelText: 'Tồn kho',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _evaluateController,
                    decoration: InputDecoration(
                      labelText: 'Đánh giá',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      return validateField(value);
                    },
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 16.0),
                  SizedBox(
                    width: 10,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String imagePath = widget.product.imagePath;
                          if (_imageFile != null) {
                            imagePath =
                                await viewModel.uploadImage(_imageFile!);
                          }
                          Product updatedProduct = Product(
                            id: widget.product.id,
                            imagePath: imagePath,
                            description: _descriptionController.text,
                            // price: double.parse(_priceController.text),
                            price: double.parse(_priceController.text.replaceAll(
                                ',',
                                '')), // Lưu giá trị với dấu phân cách vào Firestore
                            size: _setSize!,
                            evaluate: double.parse(_evaluateController.text),
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
                        }
                      },
                      child: Text(
                        'Cập nhật',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(89, 180, 195, 1.0),
        );
      },
    );
  }
}
