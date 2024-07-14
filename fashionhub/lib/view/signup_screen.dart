// import 'package:fashionhub/animation/animation.dart';
// import 'package:fashionhub/service/authentication_service.dart';
// import 'package:fashionhub/view/login_screen.dart';
// import 'package:fashionhub/viewmodel/signup_viewmodel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController displayNameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   final role = "user";
//   final locked = false;

//   final SignUpViewModel _signUpViewModel =
//       SignUpViewModel(authenticationService: AuthenticationService());

//   Offset _offset = Offset(0, 1);
//   bool _obscurePassword = true;
//   @override
//   void initState() {
//     super.initState();
//     _startAnimation();
//   }

//   void _startAnimation() {
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         _offset = Offset(0, 0);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: SingleChildScrollView(
//         child: Form(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 FadeAnimation(
//                   0.2,
//                   TextFormField(
//                     inputFormatters: [
//                       FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                     ],
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: Icon(Icons.email),
//                       labelText: 'Email',
//                       hintText: 'Enter your email',
//                       hintStyle: TextStyle(
//                         color: Colors.black26,
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 FadeAnimation(
//                   0.3,
//                   TextFormField(
//                     inputFormatters: [
//                       FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                     ],
//                     controller: passwordController,
//                     obscureText: _obscurePassword,
//                     obscuringCharacter: '*',
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: Icon(Icons.password),
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: _obscurePassword ? Colors.grey : Colors.blue,
//                         ),
//                       ),
//                       labelText: 'Password',
//                       hintText: 'Enter your password',
//                       hintStyle: TextStyle(
//                         color: Colors.black26,
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 FadeAnimation(
//                   0.4,
//                   TextFormField(
//                     inputFormatters: [
//                       FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                     ],
//                     controller: displayNameController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: Icon(Icons.people),
//                       labelText: 'Name',
//                       hintText: 'Enter your name',
//                       hintStyle: TextStyle(
//                         color: Colors.black26,
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 FadeAnimation(
//                   0.5,
//                   TextFormField(
//                     inputFormatters: [
//                       FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                     ],
//                     controller: addressController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: Icon(Icons.local_convenience_store_outlined),
//                       labelText: 'Address',
//                       hintText: 'Enter your address',
//                       hintStyle: TextStyle(
//                         color: Colors.black26,
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 FadeAnimation(
//                   0.5,
//                   TextFormField(
//                     keyboardType: TextInputType.phone,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                       FilteringTextInputFormatter.digitsOnly
//                     ],
//                     controller: phoneController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: Icon(Icons.phone),
//                       labelText: 'Phone',
//                       hintText: 'Enter your Phone',
//                       hintStyle: TextStyle(
//                         color: Colors.black26,
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Vui lòng nhập số điện thoại';
//                       } else if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
//                         return 'Số điện thoại phải bắt đầu bằng 0 và có đủ 10 chữ số';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 FadeAnimation(
//                   0.6,
//                   ElevatedButton(
//                     onPressed: () async {
//                       String email = emailController.text.trim();
//                       String password = passwordController.text.trim();
//                       String displayName = displayNameController.text.trim();
//                       String address = addressController.text.trim();
//                       String phone = phoneController.text.trim();

//                       print("Attempting to sign up with email: $email");

//                       if (email.isEmpty ||
//                           password.isEmpty ||
//                           displayName.isEmpty ||
//                           address.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text('Vui lòng điền đầy đủ các thông tin')));
//                         return;
//                       }
//           //kiểm tra email tồn tại
//                       AuthenticationService view = AuthenticationService();
//                       bool isEmailInUse = await view.isEmailAlreadyInUse(email);
//                       if (isEmailInUse) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text('Email đã được sử dụng.'),
//                         ));
//                         return;
//                       }
//                       // Kiểm tra mật khẩu
//                       final passwordRegex = RegExp(r'^.{6,}$');

//                       if (!passwordRegex.hasMatch(password)) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text('Mật khẩu phải có ít nhất 6 ký tự')));
//                         return;
//                       }

//                       // Kiểm tra định dạng email
//                       final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
//                       if (!emailRegex.hasMatch(email)) {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text('Địa chỉ email không hợp lệ')));
//                         return;
//                       }
//                       User? user = await _signUpViewModel.signUp(email, password,
//                           displayName, address, phone, role, locked == false, '');
//                       if (user != null) {
//                         print("Sign up successful, user: ${user.email}");
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(
//                                 'Đăng ký thành công. Vui lòng xác nhận email của bạn.')));
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => LoginScreen()),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Đăng ký thất bại')));
//                       }
//                     },
//                     child: Text('Sign Up'),
//                   ),

//                   // ElevatedButton(
//                   //   onPressed: () async {
//                   //     String email = emailController.text.trim();
//                   //     String password = passwordController.text.trim();
//                   //     String displayName = displayNameController.text.trim();
//                   //     String address = addressController.text.trim();
//                   //     String phone = phoneController.text.trim();
//                   //     print("Attempting to sign up with email: $email");

//                   //     if (email.isEmpty ||
//                   //         password.isEmpty ||
//                   //         displayName.isEmpty ||
//                   //         address.isEmpty) {
//                   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //           content: Text('Vui lòng điền đầy đủ các thông tin')));
//                   //       return;
//                   //     }
//                   //     //kiểm tra email tồn tại
//                   //     AuthenticationService view = AuthenticationService();
//                   //     bool isEmailInUse = await view.isEmailAlreadyInUse(email);
//                   //     if (isEmailInUse) {
//                   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //         content: Text('Email đã được sử dụng.'),
//                   //       ));
//                   //       return;
//                   //     }
//                   //     // Kiểm tra mật khẩu
//                   //     final passwordRegex =
//                   //         RegExp(r'^(?=.*[A-Z])(?=.*\W)(?!.*\s).{6,}$');
//                   //     if (!passwordRegex.hasMatch(password)) {
//                   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //           content: Text(
//                   //               'Mật khẩu phải có ít nhất 6 ký tự, chứa ít nhất một chữ hoa, một ký tự đặc biệt và không chứa khoảng trắng')));
//                   //       return;
//                   //     }
//                   //     // Kiểm tra định dạng email
//                   //     final emailRegex =
//                   //         RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                   //     if (!emailRegex.hasMatch(email) ||
//                   //         !email.endsWith('@gmail.com')) {
//                   //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //           content: Text('Địa chỉ email không hợp lệ')));
//                   //       return;
//                   //     }

//                   //     try {
//                   //       User? user = await _signUpViewModel.signUp(
//                   //           email, password, displayName, address, phone);
//                   //       if (user != null) {
//                   //         print("Sign up successful, user: ${user.email}");
//                   //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //             content: Text(
//                   //                 'Đăng ký thành công. Vui lòng xác nhận email của bạn.')));
//                   //         Navigator.push(
//                   //           context,
//                   //           MaterialPageRoute(
//                   //               builder: (context) => LoginScreen()),
//                   //         );
//                   //       }
//                   //     } on FirebaseAuthException catch (e) {
//                   //       if (e.code == 'email-already-in-use') {
//                   //         // Hiển thị thông báo cho người dùng khi email đã được sử dụng
//                   //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //             content: Text(
//                   //                 'Email đã được sử dụng. Vui lòng sử dụng một email khác.')));
//                   //       } else {
//                   //         print('Lỗi khi đăng ký: ${e.message}');
//                   //       }
//                   //     }
//                   //   },
//                   //   child: Text('Sign Up'),
//                   // ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Color.fromRGBO(89, 180, 195, 1.0), // Màu nền xanh lá
//     );
//   }
// }

import 'package:fashionhub/animation/animation.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/login_screen.dart';
import 'package:fashionhub/viewmodel/signup_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final role = "user";
  final locked = false;

  final SignUpViewModel _signUpViewModel =
      SignUpViewModel(authenticationService: AuthenticationService());

  Offset _offset = Offset(0, 1);
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _offset = Offset(0, 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FadeAnimation(
                  0.2,
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      hintText: 'Nhập email',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
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
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Vui lòng nhập email';
                    //   }
                    //   final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    //   if (!emailRegex.hasMatch(value)) {
                    //     return 'Địa chỉ email không hợp lệ';
                    //   }
                    //   return null;
                    // },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      // Biểu thức chính quy để kiểm tra email hợp lệ với các domain cụ thể
                      final emailRegex = RegExp(
                          r'^[^@]+@(gmail\.com|yahoo\.com|[^@\.]+\.vn)$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Địa chỉ email không hợp lệ.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                FadeAnimation(
                  0.3,
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _obscurePassword ? Colors.grey : Colors.blue,
                        ),
                      ),
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                FadeAnimation(
                  0.4,
                  TextFormField(
                    inputFormatters: [NoLeadingSpacesFormatter()],
                    controller: displayNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.people),
                      labelText: 'Họ Tên',
                      hintText: 'Nhập họ tên',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                FadeAnimation(
                  0.5,
                  TextFormField(
                    inputFormatters: [NoLeadingSpacesFormatter()],
                    controller: addressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.local_convenience_store_outlined),
                      labelText: 'Địa chỉ',
                      hintText: 'Nhập địa chỉ',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                FadeAnimation(
                  0.5,
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Điện thoại',
                      hintText: 'Nhập sđt',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      } else if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                        return 'Số điện thoại phải bắt đầu bằng 0 và có đủ 10 chữ số';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                FadeAnimation(
                  0.6,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(horizontal: 140),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();
                        String displayName = displayNameController.text.trim();
                        String address = addressController.text.trim();
                        String phone = phoneController.text.trim();

                        print("Attempting to sign up with email: $email");

                        // Kiểm tra email tồn tại
                        AuthenticationService view = AuthenticationService();
                        bool isEmailInUse =
                            await view.isEmailAlreadyInUse(email);

                        if (isEmailInUse) {
                          setState(() {
                            _formKey.currentState!.validate();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Email đã được sử dụng.'),
                            ));
                          });
                          return;
                        }

                        final passwordRegex = RegExp(r'^.{6,}$');
                        if (!passwordRegex.hasMatch(password)) {
                          setState(() {
                            _formKey.currentState!.validate();
                          });
                          return;
                        }

                        // Kiểm tra định dạng email
                        // final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        // if (!emailRegex.hasMatch(email)) {
                        //   setState(() {
                        //     _formKey.currentState!.validate();
                        //   });
                        //   return;
                        // }

                        User? user = await _signUpViewModel.signUp(
                            email,
                            password,
                            displayName,
                            address,
                            phone,
                            role,
                            locked == false,
                            '');
                        if (user != null) {
                          print("Sign up successful, user: ${user.email}");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Đăng ký thành công. Vui lòng xác nhận email của bạn.')));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đăng ký thất bại')));
                        }
                      }
                    },
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(89, 180, 195, 1.0), // Màu nền xanh lá
    );
  }
}

class NoLeadingSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      return oldValue;
    }
    return newValue;
  }
}
