import 'package:fashionhub/model/userorder.dart';
import 'package:fashionhub/viewmodel/statistics_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statistics_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsViewModel()..fetchStatistics(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thống kê đơn hàng'),
        ),
        body: Consumer<StatisticsViewModel>(
          builder: (context, statisticsViewModel, child) {
            if (statisticsViewModel.totalOrders == 0) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tổng số đơn hàng: ${statisticsViewModel.totalOrders}'),
                  SizedBox(height: 8),
                  Text(
                      'Số đơn hàng đã duyệt: ${statisticsViewModel.approvedOrders}'),
                  SizedBox(height: 8),
                  Text(
                      'Số đơn hàng đã hủy: ${statisticsViewModel.cancelledOrders}'),
                  SizedBox(height: 8),
                  Text(
                      'Tổng doanh thu: \$${statisticsViewModel.totalRevenue.toStringAsFixed(2)}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
