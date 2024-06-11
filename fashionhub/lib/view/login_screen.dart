import 'package:fashionhub/animation/animation.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/forgotpass_screen.dart';
import 'package:fashionhub/view/home_screen.dart';
import 'package:fashionhub/view/intro_page.dart';
import 'package:fashionhub/view/signup_screen.dart';
import 'package:fashionhub/viewmodel/login_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginViewModel _loginViewModel =
      LoginViewModel(authenticationService: AuthenticationService());
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(89, 180, 195, 1.0),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(89, 180, 195, 1.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeAnimation(
                      0.1,
                      Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 20),
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
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Email',
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(color: Colors.black26),
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
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    FadeAnimation(
                      0.3,
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        controller: passwordController,
                        obscureText: obscurePassword,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          labelText: 'Password',
                          hintText: 'Enter your Password',
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                      0.4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotpassScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Quên mật khẩu',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    FadeAnimation(
                      0.5,
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                          ),
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
                            User? user = await _loginViewModel
                                .signInWithEmailAndPassword(email, password);
                            if (user != null) {
                              // Check if the account is locked
                              bool locked = await _loginViewModel
                                  .isAccountLocked(user.uid);
                              if (locked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tài khoản này đã bị khóa'),
                                  ),
                                );
                              } else {
                                await AuthenticationService()
                                    .updatePassword(password);
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) => IntroPage(),
                                //         ),
                                //       );
                                //     }
                                //   } else {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(content: Text('Đăng nhập thất bại')),
                                //     );
                                //   }
                                // },

                                // Lấy vai trò người dùng
                                String? role =
                                    await _loginViewModel.getUserRole(user.uid);

                                if (role == 'Admin') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IntroPage(),
                                    ),
                                  );
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đăng nhập thất bại')),
                              );
                            }
                          },
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    FadeAnimation(
                      0.6,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    FadeAnimation(
                      0.7,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Bạn chưa có tài khoản? ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
