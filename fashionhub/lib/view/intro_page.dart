import 'package:fashionhub/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(249, 247, 243, 243),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Logo
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Lottie.asset(
                  'assets/animation.json',
                ),
              ),
              const SizedBox(height: 10),
              //Title
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 27.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Wel', style: TextStyle(color: Colors.blue)),
                    TextSpan(
                        text: 'com', style: TextStyle(color: Colors.green)),
                    TextSpan(text: ' to ', style: TextStyle(color: Colors.red)),
                    TextSpan(
                        text: 'Fashion',
                        style: TextStyle(color: Colors.orange)),
                    TextSpan(
                        text: 'Hub', style: TextStyle(color: Colors.purple)),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              //Sub Title
              Text(
                'Khám phá phong cách của bạn cùng chúng tôi.',
                style: TextStyle(
                  fontSize: 16.5,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 345.0),

              //Start now Button
              GestureDetector(
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(234, 0, 0, 0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25.0),
                  child: const Center(
                    child: Text(
                      'Mua ngay',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
