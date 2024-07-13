import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GenerateQRCode extends StatefulWidget {
  final double totalPayment;
  const GenerateQRCode({Key? key, required this.totalPayment})
      : super(key: key);

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  String qrImageUrl = '';
  String accountNo = "0200500311111";
  String accountName = "PHAM DUC THINH";
  String description = "THANH TOAN HOA DON";
  String? formattedTotalPayment;

  @override
  void initState() {
    super.initState();
    // Format totalPayment with dots and currency
    formattedTotalPayment =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
            .format(widget.totalPayment);
    // Initialize qrImageUrl with initial totalPayment value passed from CheckOutPage
    _updateQrImageUrl(widget.totalPayment.toString());
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã sao chép vào bộ nhớ tạm')),
    );
  }

  void _updateQrImageUrl(String amount) {
    String bankId = "MB";
    String template = "compact";

    setState(() {
      qrImageUrl =
          "https://img.vietqr.io/image/$bankId-$accountNo-$template.png?amount=$amount&addInfo=$description&accountName=$accountName";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán trực tuyến'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (qrImageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Text(
                    'Mở ứng dụng Ngân Hàng để quét mã',
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    qrImageUrl,
                    width: 300,
                    height: 300,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Text('Failed to load image'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          indent: 20,
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
                          'Hoặc',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          endIndent: 20, // Lề cuối của Divider
                          thickness: 0.7,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Chuyển tiền vào Tài Khoản',
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Lưu ý: Vui lòng nhập đúng nội dung chuyển khoản và số tiền ${formattedTotalPayment ?? ''}',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Số Tài Khoản:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              accountNo,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _copyToClipboard(accountNo);
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tên Tài Khoản:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              accountName,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nội Dung Chuyển Khoản:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _copyToClipboard(description);
                          },
                          child: Icon(
                            Icons.copy_outlined,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
