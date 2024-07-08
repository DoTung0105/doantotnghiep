import 'package:flutter/material.dart';

class MomoPaymentPage extends StatefulWidget {
  const MomoPaymentPage({super.key});

  @override
  State<MomoPaymentPage> createState() => _MomoPaymentPageState();
}

class _MomoPaymentPageState extends State<MomoPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán QR'),
      ),
    );
  }
}
