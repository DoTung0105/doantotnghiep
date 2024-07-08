import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class ZaloComponent extends StatefulWidget {
  const ZaloComponent({Key? key}) : super(key: key);

  @override
  State<ZaloComponent> createState() => _ZaloComponentState();
}

class _ZaloComponentState extends State<ZaloComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isPressed = false; // Biến để lưu trạng thái khi hình ảnh được nhấn

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchZalo() async {
    const phoneNumber = '0798850495'; // Số điện thoại của người nhận tin nhắn
    final url = 'https://zalo.me/$phoneNumber';
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _onPressed() {
    _launchZalo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Hỗ trợ khách hàng',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SpinKitRipple(
                  color: Colors.blue,
                  size: 140.0,
                  controller: _controller,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: isPressed ? 110 : 100,
                  height: isPressed ? 110 : 100,
                  child: GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        isPressed = true;
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        isPressed = false;
                      });
                      _launchZalo();
                    },
                    onTapCancel: () {
                      setState(() {
                        isPressed = false;
                      });
                    },
                    child: Image.asset('lib/images/zalo.png',
                        width: 120, height: 120),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: Text(
                'Nhấn vào biểu tượng trên màn hình để được tư vấn và hổ trợ trực tiếp.',
                style: TextStyle(
                  fontSize: 18.5,
                ),
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
