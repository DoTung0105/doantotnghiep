import 'package:fashionhub/animation/animation.dart';
import 'package:fashionhub/view/list_product.dart';
import 'package:fashionhub/viewmodel/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
                      0.1,
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
                          0.2,
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
                          0.3,
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                    // Định dạng lại giá trị để có dấu phân cách hàng nghìn
                                    final formatter =
                                        NumberFormat('#,###', 'en_US');
                                    if (newValue.text.isEmpty) {
                                      return TextEditingValue
                                          .empty; // Trường hợp nhập rỗng
                                    }
                                    final newString = formatter
                                        .format(int.parse(newValue.text));
                                    return TextEditingValue(
                                      text: newString,
                                      selection: TextSelection.collapsed(
                                          offset: newString.length),
                                    );
                                  },
                                ),
                              ],
                              keyboardType: TextInputType.number,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Hãy điền thông tin đầy đủ';
                                }
                                return null;
                              },
                              //   onChanged: viewModel.setPrice,
                              onChanged: (value) {
                                viewModel.setPrice(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FadeAnimation(
                  0.4,
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
                      0.5,
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
                      0.6,
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
                  0.7,
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
                  0.8,
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     hintText: 'Warehous',
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white, // Default border color
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white, // Default border color
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.number,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Hãy điền thông tin đầy đủ';
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: viewModel.setWarehouse,
                  // ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Warehous',
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
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true), // Cho phép nhập số và số thập phân
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp(
                    //       r'^\d+\.?\d{0,2}$')), // Chỉ cho phép số và dấu chấm (.)
                    // ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy điền thông tin đầy đủ';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      viewModel
                          .setWarehouse(value); // Lưu giá trị vào ViewModel
                    },
                  ),
                ),
                SizedBox(height: 10),
                FadeAnimation(
                  0.9,
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     hintText: 'sold',
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white, // Default border color
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.white, // Default border color
                  //       ),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.number,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Hãy điền thông tin đầy đủ';
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: (value) {
                  //     int? soldValue = int.tryParse(value);
                  //     if (soldValue != null) {
                  //       viewModel.setSold(soldValue);
                  //     }
                  //   },
                  // ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'sold',
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
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true), // Cho phép nhập số và số thập phân
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy điền thông tin đầy đủ';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      int? soldValue = int.tryParse(value);
                      if (soldValue != null) {
                        viewModel
                            .setSold(soldValue); // Lưu giá trị vào ViewModel
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                FadeAnimation(
                  1,
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Evaluate',
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hãy điền thông tin đầy đủ';
                      }
                      return null;
                    },
                    onChanged: viewModel.setEvaluate,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    FadeAnimation(
                      1.1,
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
                                    content:
                                        Text('Product added successfully')),
                              );
                              viewModel.resetImage();
                              ProductViewModel productViewModel =
                                  ProductViewModel();
                              productViewModel.resetFields();
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
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null) {
                          _formKey.currentState!.reset();
                          // Reset values in ViewModel
                          viewModel.resetFields();
                        }
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
