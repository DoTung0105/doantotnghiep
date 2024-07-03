// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:fashionhub/viewmodel/statistics_viewmodel.dart';
// import 'package:provider/provider.dart';

// class Statistics_Screen extends StatefulWidget {
//   @override
//   _StatisticsScreenState createState() => _StatisticsScreenState();
// }

// class _StatisticsScreenState extends State<Statistics_Screen> {
//   DateTime? _selectedMonth;

//   Future<void> _selectMonth(BuildContext context) async {
//     DateTime initialDate = _selectedMonth ?? DateTime.now();
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),

//       //selectableDayPredicate: (DateTime val) => val.day == 1,
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedMonth = DateTime(pickedDate.year, pickedDate.month);
//       });
//       Provider.of<StatisticsViewModel>(context, listen: false)
//           .calculateRevenueForSelectedMonth(_selectedMonth!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => StatisticsViewModel()..fetchStatistics(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Thống kê đơn hàng'),
//         ),
//         body: Consumer<StatisticsViewModel>(
//           builder: (context, statisticsViewModel, child) {
//             if (statisticsViewModel.totalOrders == 0) {
//               return Center(child: CircularProgressIndicator());
//             }

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                         'Tổng số đơn hàng: ${statisticsViewModel.totalOrders}'),
//                     SizedBox(height: 8),
//                     Text(
//                         'Số đơn hàng đã duyệt: ${statisticsViewModel.approvedOrders}'),
//                     SizedBox(height: 8),
//                     Text(
//                         'Số đơn hàng đã hủy: ${statisticsViewModel.cancelledOrders}'),
//                     SizedBox(height: 8),
//                     Text(
//                         'Tổng doanh thu: ${NumberFormat('#,###').format(statisticsViewModel.totalRevenue)}'),
//                     SizedBox(height: 16),
//                     // Text('Doanh thu theo tháng:'),
//                     // ...statisticsViewModel.monthlyRevenue.entries.map((entry) {
//                     //   return Padding(
//                     //     padding: const EdgeInsets.symmetric(vertical: 4.0),
//                     //     child: Text(
//                     //         '${entry.key}: ${NumberFormat('#,###').format(entry.value)}'),
//                     //   );
//                     // }).toList(),
//                     SizedBox(height: 16),
//                     Text('Chọn tháng để xem doanh thu:'),
//                     SizedBox(height: 8),
//                     ElevatedButton(
//                       onPressed: () => _selectMonth(context),
//                       child: Text(_selectedMonth == null
//                           ? 'Chọn tháng'
//                           : DateFormat('MM/yyyy').format(_selectedMonth!)),
//                     ),
//                     if (_selectedMonth != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 16),
//                           Text(
//                             'Doanh thu tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}: ${NumberFormat('#,###').format(statisticsViewModel.selectedMonthRevenue)}',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'Tổng số đơn hàng đã duyệt của tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}: ${statisticsViewModel.selectedMonthApprovedOrders}',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'Tổng số đơn hàng đã huỷ của tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}: ${statisticsViewModel.selectedMonthCancelledOrders}',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fashionhub/viewmodel/statistics_viewmodel.dart';
import 'package:provider/provider.dart';

class Statistics_Screen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<Statistics_Screen> {
  DateTime? _selectedMonth;

  Future<void> _selectMonth(BuildContext context) async {
    DateTime initialDate = _selectedMonth ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedMonth = DateTime(pickedDate.year, pickedDate.month);
      });
      Provider.of<StatisticsViewModel>(context, listen: false)
          .calculateRevenueForSelectedMonth(_selectedMonth!);
    }
  }

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

            List<MonthlyRevenue> monthlyRevenueData =
                statisticsViewModel.getMonthlyRevenueData();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Tổng số đơn hàng: ${statisticsViewModel.totalOrders}'),
                    SizedBox(height: 8),
                    Text(
                        'Số đơn hàng đã duyệt: ${statisticsViewModel.approvedOrders}'),
                    SizedBox(height: 8),
                    Text(
                        'Số đơn hàng đã hủy: ${statisticsViewModel.cancelledOrders}'),
                    SizedBox(height: 8),
                    Text(
                        'Tổng doanh thu: ${NumberFormat('#,###').format(statisticsViewModel.totalRevenue)}'),
                    SizedBox(height: 16),
                    Text('Chọn tháng để xem doanh thu:'),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _selectMonth(context),
                      child: Text(_selectedMonth == null
                          ? 'Chọn tháng'
                          : DateFormat('MM/yyyy').format(_selectedMonth!)),
                    ),
                    if (_selectedMonth != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Doanh thu tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}: ${NumberFormat('#,###').format(statisticsViewModel.selectedMonthRevenue)}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tổng số đơn hàng đã duyệt của tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}: ${statisticsViewModel.selectedMonthApprovedOrders}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tổng số đơn hàng đã hủy của tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}: ${statisticsViewModel.selectedMonthCancelledOrders}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    if (monthlyRevenueData.isNotEmpty)
                      SizedBox(
                        height: 300,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: monthlyRevenueData
                                    .map((e) => e.revenue)
                                    .reduce((a, b) => a > b ? a : b) *
                                1.2,
                            barGroups:
                                monthlyRevenueData.asMap().entries.map((entry) {
                              int index = entry.key;
                              MonthlyRevenue data = entry.value;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: data.revenue,
                                    color: Colors.blue,
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                                //  ${NumberFormat('#,###').format(statisticsViewModel.selectedMonthRevenue)}',
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 5000 == 0 && value != 0) {
                                      return Text('${value ~/ 1000}k');
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      monthlyRevenueData[value.toInt()].month,
                                      //  ${NumberFormat('#,###').format(statisticsViewModel.selectedMonthRevenue)}',
                                    );
                                  },
                                ),
                              ),
                            ),
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipMargin: 8,
                                tooltipPadding: const EdgeInsets.all(8),
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  final revenue = rod.toY;
                                  return BarTooltipItem(
                                    '${NumberFormat('#,###').format(revenue)} VNĐ',
                                    TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
