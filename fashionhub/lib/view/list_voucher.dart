import 'package:fashionhub/viewmodel/voucher_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListVoucher extends StatefulWidget {
  final totalPayment;
  const ListVoucher({Key? key, required this.totalPayment}) : super(key: key);

  @override
  State<ListVoucher> createState() => _ListVoucherState();
}

class _ListVoucherState extends State<ListVoucher> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<VoucherViewModel>(context, listen: false).fetchVouchers();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã sao chép vào bộ nhớ tạm')),
    );
  }

  String getConditionMessage(int discount, double totalPayment) {
    if (discount == 10 && totalPayment < 49000) {
      return 'Chỉ áp dụng cho đơn hàng từ 49.000đ trở lên.';
    } else if (discount == 35 && totalPayment < 149000) {
      return 'Chỉ áp dụng cho đơn hàng từ 149.000đ trở lên.';
    } else if (discount == 50 && totalPayment < 349000) {
      return 'Chỉ áp dụng cho đơn hàng từ 349.000đ trở lên.';
    } else if (discount == 100 && totalPayment < 499000) {
      return 'Chỉ áp dụng cho đơn hàng từ 499.000đ trở lên.';
    } else {
      return '${discount}%';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Voucher vận chuyển',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 89, 38),
      ),
      body: Consumer<VoucherViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isLoading) {
            return ListView.builder(
              itemCount: viewModel.vouchers.length,
              itemBuilder: (context, index) {
                var voucher = viewModel.vouchers[index];
                String conditionMessage = getConditionMessage(
                    int.parse(voucher.discount), widget.totalPayment);
                if (conditionMessage.startsWith('Chỉ áp dụng')) {
                  return SizedBox(); // Ẩn voucher nếu không đủ điều kiện
                }
                return Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 2),
                  decoration: BoxDecoration(
                    // Chuyển màu từ phải sang trái
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 123, 191, 194),
                        Colors.white,
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height * 0.143,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border(
                            right: BorderSide(color: Colors.black),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${voucher.discount}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Mã khuyến mãi:'),
                                const SizedBox(width: 5),
                                Text(
                                  voucher.promotionalId,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    _copyToClipboard(voucher.promotionalId);
                                  },
                                  child: Image.asset(
                                    'lib/images/copy.png',
                                    width: 18,
                                    height: 18,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'HSD: ${DateFormat('dd/MM/yyyy').format(voucher.expiry.toDate())}',
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                'Nhập voucher để giảm ngay ${getConditionMessage(int.parse(voucher.discount), widget.totalPayment)} phí vận chuyển.',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
