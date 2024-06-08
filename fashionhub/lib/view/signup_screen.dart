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

  final SignUpViewModel _signUpViewModel =
      SignUpViewModel(authenticationService: AuthenticationService());

  Offset _offset = Offset(0, 1);
  bool _obscurePassword = true;
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
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    hintText: 'Enter your email',
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
                      ),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter your password',
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
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                0.4,
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  controller: displayNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.people),
                    labelText: 'Name',
                    hintText: 'Enter your name',
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
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                0.5,
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  controller: addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.local_convenience_store_outlined),
                    labelText: 'Address',
                    hintText: 'Enter your address',
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
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                0.5,
                TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  controller: phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Phone',
                    hintText: 'Enter your Phone',
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
                ),
              ),
              SizedBox(height: 20),
              FadeAnimation(
                0.6,
                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    String displayName = displayNameController.text.trim();
                    String address = addressController.text.trim();
                    String phone = phoneController.text.trim();
                    print("Attempting to sign up with email: $email");

                    if (email.isEmpty ||
                        password.isEmpty ||
                        displayName.isEmpty ||
                        address.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Vui lòng điền đầy đủ các thông tin')));
                      return;
                    }
//kiểm tra email tồn tại
                    AuthenticationService view = AuthenticationService();
                    bool isEmailInUse = await view.isEmailAlreadyInUse(email);
                    if (isEmailInUse) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Email đã được sử dụng.'),
                      ));
                      return;
                    }
                    // Kiểm tra mật khẩu
                    final passwordRegex =
                        RegExp(r'^(?=.*[A-Z])(?=.*\W)(?!.*\s).{6,}$');
                    if (!passwordRegex.hasMatch(password)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Mật khẩu phải có ít nhất 6 ký tự, chứa ít nhất một chữ hoa, một ký tự đặc biệt và không chứa khoảng trắng')));
                      return;
                    }
                    // Kiểm tra định dạng email
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(email) ||
                        !email.endsWith('@gmail.com')) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Địa chỉ email không hợp lệ')));
                      return;
                    }
                    User? user = await _signUpViewModel.signUp(
                        email, password, displayName, address, phone);
                    if (user != null) {
                      print("Sign up successful, user: ${user.email}");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Đăng ký thành công. Vui lòng xác nhận email của bạn.')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đăng ký thất bại')));
                    }
                  },
                  child: Text('Sign Up'),
                ),

                // ElevatedButton(
                //   onPressed: () async {
                //     String email = emailController.text.trim();
                //     String password = passwordController.text.trim();
                //     String displayName = displayNameController.text.trim();
                //     String address = addressController.text.trim();
                //     String phone = phoneController.text.trim();
                //     print("Attempting to sign up with email: $email");

                //     if (email.isEmpty ||
                //         password.isEmpty ||
                //         displayName.isEmpty ||
                //         address.isEmpty) {
                //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //           content: Text('Vui lòng điền đầy đủ các thông tin')));
                //       return;
                //     }
                //     //kiểm tra email tồn tại
                //     AuthenticationService view = AuthenticationService();
                //     bool isEmailInUse = await view.isEmailAlreadyInUse(email);
                //     if (isEmailInUse) {
                //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //         content: Text('Email đã được sử dụng.'),
                //       ));
                //       return;
                //     }
                //     // Kiểm tra mật khẩu
                //     final passwordRegex =
                //         RegExp(r'^(?=.*[A-Z])(?=.*\W)(?!.*\s).{6,}$');
                //     if (!passwordRegex.hasMatch(password)) {
                //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //           content: Text(
                //               'Mật khẩu phải có ít nhất 6 ký tự, chứa ít nhất một chữ hoa, một ký tự đặc biệt và không chứa khoảng trắng')));
                //       return;
                //     }
                //     // Kiểm tra định dạng email
                //     final emailRegex =
                //         RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                //     if (!emailRegex.hasMatch(email) ||
                //         !email.endsWith('@gmail.com')) {
                //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //           content: Text('Địa chỉ email không hợp lệ')));
                //       return;
                //     }

                //     try {
                //       User? user = await _signUpViewModel.signUp(
                //           email, password, displayName, address, phone);
                //       if (user != null) {
                //         print("Sign up successful, user: ${user.email}");
                //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //             content: Text(
                //                 'Đăng ký thành công. Vui lòng xác nhận email của bạn.')));
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => LoginScreen()),
                //         );
                //       }
                //     } on FirebaseAuthException catch (e) {
                //       if (e.code == 'email-already-in-use') {
                //         // Hiển thị thông báo cho người dùng khi email đã được sử dụng
                //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //             content: Text(
                //                 'Email đã được sử dụng. Vui lòng sử dụng một email khác.')));
                //       } else {
                //         print('Lỗi khi đăng ký: ${e.message}');
                //       }
                //     }
                //   },
                //   child: Text('Sign Up'),
                // ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(89, 180, 195, 1.0), // Màu nền xanh lá
    );
  }
}
