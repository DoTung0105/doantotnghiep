import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/login_screen.dart';
import 'package:fashionhub/viewmodel/signup_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final SignUpViewModel _signUpViewModel =
      SignUpViewModel(authenticationService: AuthenticationService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextField(
              controller: displayNameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
              ),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                String displayName = displayNameController.text.trim();
                String address = addressController.text.trim();
                print("Attempting to sign up with email: $email");

                if (email.isEmpty || password.isEmpty || displayName.isEmpty || address.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Vui lòng điền đầy đủ các thông tin')));
                  return;
                }

                // Kiểm tra mật khẩu
                final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\W)(?!.*\s).{6,}$');
                if (!passwordRegex.hasMatch(password)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Mật khẩu phải có ít nhất 6 ký tự, chứa ít nhất một chữ hoa, một ký tự đặc biệt và không chứa khoảng trắng')));
                  return;
                }

                User? user = await _signUpViewModel.signUp(
                  email,
                  password,
                  displayName,
                  address,
                );
                if (user != null) {
                  print("Sign up successful, user: ${user.email}");
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đăng ký thành công. Vui lòng xác nhận email của bạn.')));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Đăng ký thất bại')));
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

