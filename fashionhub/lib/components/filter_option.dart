import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for TextInputFormatter
import 'package:provider/provider.dart';

class FilterOption extends StatefulWidget {
  final String selectedSortOption;
  final int? minPrice;
  final int? maxPrice;
  final List<String> selectedBranches;

  const FilterOption({
    Key? key,
    required this.selectedSortOption,
    this.minPrice,
    this.maxPrice,
    required this.selectedBranches,
  }) : super(key: key);

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  late String _selectedSortOption;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  List<String> selectedBranches = [];

  final List<String> _sortOptions = [
    'Mặc định',
    'Lượt bán',
    'Đánh giá',
    'Giá từ thấp đến cao',
    'Giá từ cao đến thấp'
  ];

  late List<String> _visibleBranches;
  late List<String> _allBranches;
  bool _showMoreBranchesButton = false;
  bool _isKeyboardVisible = false;

  final FocusNode _minPriceFocusNode = FocusNode();
  final FocusNode _maxPriceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedSortOption = widget.selectedSortOption;
    _minPriceController = TextEditingController(
        text: widget.minPrice != null ? widget.minPrice.toString() : '');
    _maxPriceController = TextEditingController(
        text: widget.maxPrice != null ? widget.maxPrice.toString() : '');
    selectedBranches = List.from(widget.selectedBranches);

    final cart = Provider.of<Cart>(context, listen: false);
    _allBranches = cart.getBranchesList();
    _visibleBranches = _allBranches.sublist(0, 2);
    _showMoreBranchesButton = _allBranches.length > 2;

    _minPriceFocusNode.addListener(_handleFocusChange);
    _maxPriceFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _minPriceFocusNode.dispose();
    _maxPriceFocusNode.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_minPriceFocusNode.hasFocus || _maxPriceFocusNode.hasFocus) {
      setState(() {
        _isKeyboardVisible = true;
      });
    } else {
      setState(() {
        _isKeyboardVisible = false;
      });
    }
  }

  void _onSortOptionSelected(String? newValue) {
    setState(() {
      _selectedSortOption = newValue!;
    });
  }

  void _showMoreBranches() {
    setState(() {
      if (_visibleBranches.length > 4) {
        _visibleBranches = _allBranches.sublist(0, 4);
      } else {
        _visibleBranches = _allBranches;
      }
      _showMoreBranchesButton = !_showMoreBranchesButton;
    });
  }

  void _applyFilters() {
    int? minPrice = _minPriceController.text.isNotEmpty
        ? int.tryParse(_minPriceController.text)
        : null;
    int? maxPrice = _maxPriceController.text.isNotEmpty
        ? int.tryParse(_maxPriceController.text)
        : null;
    Navigator.pop(context, {
      'sortOption': _selectedSortOption,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'selectedBranches': selectedBranches,
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedSortOption = 'Mặc định';
      _minPriceController.clear();
      _maxPriceController.clear();
      selectedBranches.clear();
    });
  }

  void _toggleBranchSelection(String branch) {
    setState(() {
      if (selectedBranches.contains(branch)) {
        selectedBranches.remove(branch);
      } else {
        selectedBranches.add(branch);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sắp xếp theo',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: _selectedSortOption,
                            onChanged: (String? newValue) {
                              _onSortOptionSelected(newValue);
                            },
                            items: _sortOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const Text(
                        'Khoảng Giá (₫)',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 15,
                        height: 80,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                child: TextField(
                                  focusNode: _minPriceFocusNode,
                                  controller: _minPriceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    NonNegativeIntFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Tối Thiểu',
                                    border: OutlineInputBorder(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Text(
                              ' - ',
                              style: TextStyle(fontSize: 30),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                child: TextField(
                                  focusNode: _maxPriceFocusNode,
                                  controller: _maxPriceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    NonNegativeIntFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Tối Đa',
                                    border: OutlineInputBorder(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Text(
                        'Thương Hiệu',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _visibleBranches.map((branch) {
                            return BranchRangeContainer(
                              text: branch,
                              isSelected: selectedBranches.contains(branch),
                              onTap: () => _toggleBranchSelection(branch),
                            );
                          }).toList(),
                        ),
                      ),
                      if (_showMoreBranchesButton)
                        TextButton(
                          onPressed: _showMoreBranches,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Xem thêm'),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        )
                      else
                        TextButton(
                          onPressed: _showMoreBranches,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Ẩn bớt'),
                              Icon(Icons.arrow_drop_up)
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                if (!_isKeyboardVisible) ...[
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _resetFilters,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 55,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(235, 245, 97, 34),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Thiết lập lại',
                              style: TextStyle(
                                color: Color.fromARGB(235, 245, 97, 34),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _applyFilters,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 55,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(235, 245, 97, 34),
                          ),
                          child: const Center(
                            child: Text(
                              'Áp dụng',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
