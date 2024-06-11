import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fashionhub/components/clother_selling.dart';
import 'package:fashionhub/components/clother_tile.dart';
import 'package:fashionhub/components/filter_option.dart';
import 'package:fashionhub/model/cart.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:fashionhub/view/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final CarouselController _carouselController = CarouselController();
  late Timer _timer;
  late List<Clother> topSellingClotherList;
  late List<Clother> allClotherList;
  int _currentPage = 0;
  String _selectedSortOption = 'Mặc định';
  int? _minPrice;
  int? _maxPrice;
  List<String> _selectedBranches = []; // Thêm thuộc tính này

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (topSellingClotherList.isNotEmpty) {
        int nextPage = _currentPage + 1;
        if (nextPage >= topSellingClotherList.length) {
          nextPage = 0;
        }
        _carouselController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });

    _minPrice = null; // Thay đổi giá trị ban đầu thành null
    _maxPrice = null; // Thay đổi giá trị ban đầu thành null
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void navToClotherDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          detailCol: allClotherList[index],
        ),
      ),
    );
  }

  void _showFilterOptions() async {
    final filters = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: FilterOption(
            selectedSortOption: _selectedSortOption,
            minPrice: _minPrice ?? 0,
            maxPrice: _maxPrice ?? 0,
            selectedBranches: _selectedBranches, // Thêm thuộc tính này
          ),
        );
      },
    );

    if (filters != null) {
      setState(() {
        _selectedSortOption = filters['sortOption'];
        _minPrice = filters['minPrice'];
        _maxPrice = filters['maxPrice'];
        _selectedBranches = filters[
            'selectedBranches']; // Cập nhật danh sách thương hiệu đã chọn
      });
    }
  }

  List<Clother> _applyPriceFilter(List<Clother> clotherList) {
    if ((_minPrice == null || _minPrice == 0) &&
        (_maxPrice == null || _maxPrice == 0)) {
      return clotherList;
    }

    final filteredList = clotherList.where((clother) {
      final price = double.tryParse(clother.price.replaceAll('.', ''));
      if (price == null) return false;

      if (_minPrice != null && _maxPrice != null) {
        return price >= _minPrice! && price <= _maxPrice!;
      } else if (_minPrice != null) {
        return price >= _minPrice!;
      } else if (_maxPrice != null) {
        return price <= _maxPrice!;
      }

      return true;
    }).toList();

    return filteredList;
  }

  List<Clother> _applyBranchFilter(List<Clother> clotherList) {
    if (_selectedBranches.isEmpty) {
      return clotherList;
    }

    return clotherList
        .where((clother) => _selectedBranches.contains(clother.brand))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      body: Consumer<Cart>(
        builder: (context, value, child) {
          allClotherList = value.sortClotherList(_selectedSortOption);
          allClotherList = _applyPriceFilter(allClotherList);
          allClotherList =
              _applyBranchFilter(allClotherList); // Áp dụng bộ lọc thương hiệu
          topSellingClotherList =
              value.cloShop.where((clother) => clother.sold >= 1000).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        '🏆 Top bán chạy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: CarouselSlider.builder(
                      itemCount: topSellingClotherList.length,
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.8,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.9,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        if (index >= 0 &&
                            index < topSellingClotherList.length) {
                          Clother clother = topSellingClotherList[index];
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: CloSelling(
                                    cloSel: clother,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox(); // Trả về widget trống nếu index không hợp lệ
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SmoothPageIndicator(
                  controller: PageController(initialPage: _currentPage),
                  count: topSellingClotherList.length,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.black,
                  ),
                  onDotClicked: (index) {
                    _carouselController.animateToPage(index);
                  },
                ),
                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Danh sách sản phẩm',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_list_bulleted_rounded),
                        onPressed: _showFilterOptions,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                allClotherList.isEmpty
                    ? const Center(
                        child: Text(
                          'Không có sản phẩm',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: allClotherList.length,
                        itemBuilder: (context, index) {
                          Clother clother = allClotherList[index];
                          return GestureDetector(
                            onTap: () {
                              navToClotherDetails(index);
                            },
                            child: ClotherTile(cloTil: clother),
                          );
                        },
                      ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 35, right: 35),
                  child: SizedBox(
                    height: 1,
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
