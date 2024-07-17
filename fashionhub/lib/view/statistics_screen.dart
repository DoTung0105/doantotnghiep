import 'package:fashionhub/viewmodel/statistics_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Statistics_Screen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<Statistics_Screen> {
  DateTime? _selectedMonth;

  String _selectedQuarter = '1';
  int _selectedYear = DateTime.now().year;
  int _selecmoreyear = DateTime.now().year;
  Future<void> _selectMonth(BuildContext context) async {
    DateTime initialDate = _selectedMonth ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Colors.blue),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
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
          title: const Text('Thống kê đơn hàng'),
        ),
        body: Consumer<StatisticsViewModel>(
          builder: (context, statisticsViewModel, child) {
            if (statisticsViewModel.totalOrders == 0) {
              return const Center(child: CircularProgressIndicator());
            }

            List<MonthlyRevenue> monthlyRevenueData =
                statisticsViewModel.getMonthlyRevenueData();

            monthlyRevenueData.sort((a, b) => a.month.compareTo(b.month));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatisticTile(
                        title: 'Tổng số đơn hàng',
                        value: '${statisticsViewModel.totalOrders}',
                        icon: Icons.receipt_long,
                        color: Colors.blue,
                      ),
                      _buildStatisticTile(
                        title: 'Số đơn hàng đang giao',
                        value: '${statisticsViewModel.shipping}',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      _buildStatisticTile(
                        title: 'Số đơn hàng đã hủy',
                        value: '${statisticsViewModel.cancelledOrders}',
                        icon: Icons.cancel,
                        color: Colors.red,
                      ),
                      _buildStatisticTile(
                        title: 'Số đơn hàng chờ xác nhận',
                        value: '${statisticsViewModel.pendingOrders}',
                        icon: Icons.pending,
                        color: Colors.orange,
                      ),
                      _buildStatisticTile(
                        title: 'Số đơn hàng thành công',
                        value: '${statisticsViewModel.success}',
                        icon: Icons.shopping_bag_outlined,
                        color: Colors.pink,
                      ),
                      _buildStatisticTile(
                        title: 'Tổng doanh thu',
                        value:
                            '${NumberFormat('#,###').format(statisticsViewModel.totalRevenue)} VNĐ',
                        icon: Icons.attach_money,
                        color: Colors.purple,
                      ),
                      const Text(
                        "Thống kê theo năm: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<int>(
                        value: _selecmoreyear,
                        onChanged: (int? value) {
                          setState(() {
                            _selecmoreyear = value!;
                            statisticsViewModel
                                .calculateYearlyRevenue(_selecmoreyear);
                          });
                        },
                        items: List<int>.generate(
                                10, (index) => DateTime.now().year - index)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),

                      // Display total revenue for the selected year
                      _buildStatisticTile(
                        title: 'Tổng doanh thu năm $_selecmoreyear',
                        value:
                            '${NumberFormat('#,###').format(statisticsViewModel.yearlyRevenue[_selecmoreyear] ?? 0)} VNĐ',
                        isBold: true,
                        icon: Icons.attach_money,
                        color: Colors.purple,
                      ),

                      const Text(
                        "Thống kê theo quý: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: _selectedQuarter,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedQuarter = value!;
                                    statisticsViewModel
                                        .calculateQuarterlyStatistics(
                                            _selectedYear, _selectedQuarter);
                                  });
                                },
                                items: <String>[
                                  '1',
                                  '2',
                                  '3',
                                  '4'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text('Quý $value'),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(width: 20),
                              DropdownButton<int>(
                                value: _selectedYear,
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedYear = value!;
                                    statisticsViewModel
                                        .calculateQuarterlyStatistics(
                                            _selectedYear, _selectedQuarter);
                                  });
                                },
                                items: List<int>.generate(10,
                                        (index) => DateTime.now().year - index)
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildStatisticTile(
                            title: 'Tổng doanh thu quý ${_selectedQuarter}',
                            value:
                                '${NumberFormat('#,###').format(statisticsViewModel.quarterlyRevenue[_selectedQuarter] ?? 0)} VNĐ',
                            isBold: true,
                            icon: Icons.attach_money,
                            color: Colors.purple,
                          ),
                          _buildStatisticTile(
                            title:
                                'Tổng số đơn hàng thành công quý ${_selectedQuarter}',
                            value:
                                '${statisticsViewModel.quarterlyApprovedOrders}',
                            isBold: true,
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                          _buildStatisticTile(
                            title:
                                'Tổng số đơn hàng đã hủy quý ${_selectedQuarter}',
                            value:
                                '${statisticsViewModel.quarterlyCancelledOrders}',
                            isBold: true,
                            icon: Icons.cancel,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Chọn tháng để xem doanh thu:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _selectMonth(context),
                        child: Text(
                          _selectedMonth == null
                              ? 'Chọn tháng'
                              : DateFormat('MM/yyyy').format(_selectedMonth!),
                        ),
                      ),
                      if (_selectedMonth != null) ...[
                        const SizedBox(height: 16),
                        _buildStatisticTile(
                          title:
                              'Doanh thu tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}',
                          value:
                              '${NumberFormat('#,###').format(statisticsViewModel.selectedMonthRevenue)} VNĐ',
                          isBold: true,
                          icon: Icons.calendar_today,
                          color: Colors.teal,
                        ),
                        _buildStatisticTile(
                          title:
                              'Tổng số đơn hàng thành công của tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}',
                          value:
                              '${statisticsViewModel.selectedMonthApprovedOrders}',
                          isBold: true,
                          icon: Icons.check_circle,
                          color: Colors.green,
                        ),
                        _buildStatisticTile(
                          title:
                              'Tổng số đơn hàng đã hủy của tháng ${DateFormat('MM/yyyy').format(_selectedMonth!)}',
                          value:
                              '${statisticsViewModel.selectedMonthCancelledOrders}',
                          isBold: true,
                          icon: Icons.cancel,
                          color: Colors.red,
                        ),
                      ],
                      const SizedBox(height: 16),
                      // if (monthlyRevenueData.isNotEmpty)
                      // SizedBox(
                      //   height: 300,
                      //   child: Card(
                      //     elevation: 4,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(16.0),
                      //       child: BarChart(
                      //         BarChartData(
                      //           alignment: BarChartAlignment.spaceAround,
                      //           maxY: monthlyRevenueData
                      //                   .map((e) => e.revenue)
                      //                   .reduce((a, b) => a > b ? a : b) *
                      //               1.2,
                      //           barGroups: monthlyRevenueData
                      //               .asMap()
                      //               .entries
                      //               .map((entry) {
                      //             int index = entry.key;
                      //             MonthlyRevenue data = entry.value;
                      //             return BarChartGroupData(
                      //               x: index,
                      //               barRods: [
                      //                 BarChartRodData(
                      //                   toY: data.revenue,
                      //                   color: Colors.blue,
                      //                 ),
                      //               ],
                      //               showingTooltipIndicators: [0],
                      //             );
                      //           }).toList(),
                      //           titlesData: FlTitlesData(
                      //             leftTitles: AxisTitles(
                      //               sideTitles: SideTitles(
                      //                 showTitles: true,
                      //                 reservedSize: 40,
                      //                 getTitlesWidget: (value, meta) {
                      //                   if (value % 5000 == 0 && value != 0) {
                      //                     return Text('${value ~/ 1000}k');
                      //                   }
                      //                   return Container();
                      //                 },
                      //               ),
                      //             ),
                      //             bottomTitles: AxisTitles(
                      //               sideTitles: SideTitles(
                      //                 showTitles: true,
                      //                 getTitlesWidget: (value, meta) {
                      //                   return Text(
                      //                     monthlyRevenueData[value.toInt()]
                      //                         .month,
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //           barTouchData: BarTouchData(
                      //             touchTooltipData: BarTouchTooltipData(
                      //               tooltipMargin: 8,
                      //               tooltipPadding: const EdgeInsets.all(8),
                      //               getTooltipItem:
                      //                   (group, groupIndex, rod, rodIndex) {
                      //                 final revenue = rod.toY;
                      //                 return BarTooltipItem(
                      //                   '${NumberFormat('#,###').format(revenue)} VNĐ',
                      //                   TextStyle(color: Colors.white),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatisticTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isBold = false,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 36),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
