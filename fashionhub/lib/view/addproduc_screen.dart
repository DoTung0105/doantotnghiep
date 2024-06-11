import 'package:fashionhub/animation/animation.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color.fromARGB(255, 39, 176, 112),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(
                      0.8,
                      GestureDetector(
                        onTap: viewModel.pickImage,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              viewModel.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        viewModel.image!,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.camera_alt_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeAnimation(
                          0.6,
                          SizedBox(
                            width: 210,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Tên sản phẩm',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Hãy điền thông tin đầy đủ';
                                }
                                return null;
                              },
                              onChanged: viewModel.setName,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        FadeAnimation(
                          0.2,
                          SizedBox(
                            width: 210,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Giá',
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
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Hãy điền thông tin đầy đủ';
                                }
                                return null;
                              },
                              onChanged: viewModel.setPrice,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FadeAnimation(
                  0.1,
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Mô tả',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy điền thông tin đầy đủ';
                      }
                      return null;
                    },
                    onChanged: viewModel.setDescription,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeAnimation(
                      0.3,
                      SizedBox(
                        width: 133,
                        child: DropdownButtonFormField<String>(
                          value:
                              viewModel.size.isNotEmpty ? viewModel.size : null,
                          decoration: InputDecoration(
                            hintText: 'Size',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: viewModel.sizeoption.map((String size) {
                            return DropdownMenuItem<String>(
                              value: size,
                              child: Text(size),
                            );
                          }).toList(),
                          onChanged: viewModel.setSize,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hãy điền thông tin đầy đủ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    FadeAnimation(
                      0.5,
                      SizedBox(
                        width: 230,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Màu',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Hãy điền thông tin đầy đủ';
                            }
                            return null;
                          },
                          onChanged: viewModel.setColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FadeAnimation(
                  0.4,
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Tên thương hiệu',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy điền thông tin đầy đủ';
                      }
                      return null;
                    },
                    onChanged: viewModel.setBranch,
                  ),
                ),
                SizedBox(height: 10),
                FadeAnimation(
                  0.7,
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Warehouse',
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy điền thông tin đầy đủ';
                      }
                      return null;
                    },
                    onChanged: viewModel.serWarehouse,
                  ),
                ),
                SizedBox(height: 20),
                FadeAnimation(
                  0.9,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 100)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await viewModel.addProduct();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Product added successfully')),
                          );
                          viewModel.resetImage();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => screenproducts()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to add product: $e')),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
