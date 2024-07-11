import 'package:fashionhub/view/login_screen.dart';
import 'package:fashionhub/viewmodel/ForgotPassword_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotpassScreen extends StatefulWidget {
  const ForgotpassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotpassScreen> createState() => _ForgotpassScreenState();
}

class _ForgotpassScreenState extends State<ForgotpassScreen> {
  final TextEditingController _emailController = TextEditingController();
  final ForgotPasswordViewModel _viewModel = ForgotPasswordViewModel();
  bool _passwordResetSuccessful = false;

  // Hàm kiểm tra định dạng email
  // bool _isEmailValid(String email) {
  //   String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  //   RegExp regex = RegExp(emailPattern);
  //   return regex.hasMatch(email);
  // }
  bool _isEmailValid(String email) {
    return email.contains('@');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên Mật Khẩu'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/key.png'),
            Column(
              children: [
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: 'Email',
                    hintText: 'Enter your Email',
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                  onPressed: () async {
                    String email = _emailController.text.trim();

                    bool emailExists = await _viewModel.checkEmailExists(email);

                    if (emailExists) {
                      try {
                        await _viewModel.resetPassword(email);
                        setState(() {
                          _passwordResetSuccessful = true;
                        });

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(
                              'Vui lòng kiểm tra email để đổi mật khẩu!',
                              style: TextStyle(fontSize: 18),
                            ),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.info_rounded,
                                  color: Colors.yellow[700],
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Thông báo',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 113,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 222, 217, 217),
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: MaterialButton(
                                      child: const Text('Done'),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã xảy ra lỗi: $e'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email chưa được đăng ký'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Đặt lại mật khẩu',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // if (_passwordResetSuccessful)
            //   const Icon(
            //     Icons.check_circle,
            //     color: Colors.green,
            //     size: 24,
            //   ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[300],
    );
  }
}
