import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/voucher.dart';
import 'package:fashionhub/viewmodel/voucher_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Voucher_Screen extends StatefulWidget {
  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<Voucher_Screen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<VoucherViewModel>(context, listen: false).fetchVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Voucher'),
      ),
      body: Consumer<VoucherViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isLoading) {
            return ListView.builder(
              itemCount: viewModel.vouchers.length,
              itemBuilder: (context, index) {
                var voucher = viewModel.vouchers[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text('Mã khuyến mãi: ${voucher.promotionalId}'),
                      SizedBox(height: 8),
                      Text('Giảm giá: ${voucher.discount}%'),
                      SizedBox(height: 8),
                      Text('Số lượng: ${voucher.quanlity}'),
                      SizedBox(height: 8),
                      Text(
                        'Hết hạn: ${DateFormat('dd/MM/yyyy').format(voucher.expiry.toDate())}',
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Trạng thái: ${voucher.status ? "Hoạt động" : "Hết hiệu lực"}',
                        style: TextStyle(
                          color: voucher.status ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (voucher.status)
                            TextButton(
                              onPressed: () => _editVoucher(context, voucher),
                              child: Text('Sửa'),
                            ),
                          SizedBox(width: 8),
                          TextButton(
                            onPressed: () =>
                                _showDeleteConfirmation(context, voucher),
                            child: Text('Xóa'),
                          ),
                        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVoucherDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddVoucherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddVoucherDialog(),
    );
  }

  void _editVoucher(BuildContext context, Voucher voucher) {
    showDialog(
      context: context,
      builder: (context) => EditVoucherDialog(voucher: voucher),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Voucher voucher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa voucher này?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<VoucherViewModel>(context, listen: false)
                  .deleteVoucher(voucher.uid);
              Navigator.of(context).pop();
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

class EditVoucherDialog extends StatefulWidget {
  final Voucher voucher;

  const EditVoucherDialog({required this.voucher});

  @override
  _EditVoucherDialogState createState() => _EditVoucherDialogState();
}

class _EditVoucherDialogState extends State<EditVoucherDialog> {
  final TextEditingController _discountController =
      TextEditingController(text: '');
  final TextEditingController _quantityController =
      TextEditingController(text: '');

  DateTime _selectedExpiryDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _discountController.text = widget.voucher.discount.toString();
    _quantityController.text = widget.voucher.quanlity.toString();
    _selectedExpiryDate = widget.voucher.expiry.toDate();
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedExpiryDate)
      setState(() {
        _selectedExpiryDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chỉnh sửa Voucher',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: 'Giảm giá (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hãy điền thông tin đầy đủ';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Số lượng',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hãy điền thông tin đầy đủ';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectExpiryDate(context),
              child: Text("Chọn ngày hết hạn"),
            ),
            SizedBox(height: 10),
            Text(
              "Ngày hết hạn: ${DateFormat('dd/MM/yyyy').format(_selectedExpiryDate)}",
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Hủy'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    String discount = _discountController.text;
                    String quantity = _quantityController.text;
                    Timestamp expiry = Timestamp.fromDate(_selectedExpiryDate);

                    Provider.of<VoucherViewModel>(context, listen: false)
                        .updateVoucher(
                            widget.voucher.uid, discount, expiry, quantity);
                    Navigator.of(context).pop();
                  },
                  child: Text('Lưu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddVoucherDialog extends StatefulWidget {
  @override
  _AddVoucherDialogState createState() => _AddVoucherDialogState();
}

class _AddVoucherDialogState extends State<AddVoucherDialog> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  DateTime _selectedExpiryDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hãy điền thông tin đầy đủ';
    }
    return null;
  }

  String? _validateDiscount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hãy điền thông tin đầy đủ';
    }

    return null;
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedExpiryDate)
      setState(() {
        _selectedExpiryDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thêm Voucher',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Số lượng',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateQuantity,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(
                  labelText: 'Giảm giá (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateDiscount,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectExpiryDate(context),
                child: Text("Chọn ngày hết hạn"),
              ),
              SizedBox(height: 10),
              Text(
                "Ngày hết hạn: ${DateFormat('dd/MM/yyyy').format(_selectedExpiryDate)}",
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Hủy'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String quantity = _quantityController.text;
                        String discount = _discountController.text;
                        Timestamp expiry =
                            Timestamp.fromDate(_selectedExpiryDate);

                        Provider.of<VoucherViewModel>(context, listen: false)
                            .addVoucher(discount, expiry, quantity);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Thêm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
