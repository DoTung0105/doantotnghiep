import 'package:fashionhub/view/login_screen.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

bool _isHovering = false;

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(89, 180, 195, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(89, 180, 195, 1.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                "Welcome to Fashionhub",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(
              height: 30,
            ),
            MouseRegion(
              onHover: (_) {
                setState(() {
                  _isHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 50),
                decoration: BoxDecoration(
                  color: _isHovering ? Colors.orange : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onHover: (value) {
                    if (_isHovering) {
                      Colors.amber;
                    } else {
                      Colors.white;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Get Start",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
