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
//import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';

// class FadeAnimation extends StatelessWidget {
//   final double delay;
//   final Widget child;

//   FadeAnimation(this.delay, this.child);

//   @override
//   Widget build(BuildContext context) {
//     final tween = MovieTween()
//       ..tween('opacity', Tween(begin: 0.0, end: 1.0),
//               duration: const Duration(milliseconds: 500))
//           .thenTween('y', Tween(begin: -30.0, end: 0.0),
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeOut);

//     return PlayAnimationBuilder<Movie>(
//       delay: Duration(milliseconds: (500 * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builder: (context, value, child) => Opacity(
//         opacity: value.get("opacity"),
//         child: Transform.translate(
//             offset: Offset(0, value.get("y")), child: child),
//       ),
//     );
//   }
// }