import 'package:fashionhub/components/search_item.dart';
import 'package:fashionhub/model/cart.dart';
import 'package:fashionhub/model/clother.dart';
import 'package:fashionhub/view/cart_page.dart';
import 'package:fashionhub/view/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  final String? initialSearchQuery; // Define the initialSearchQuery parameter

  const SearchPage({Key? key, this.initialSearchQuery}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  List<String> recentSearches = [];
  bool showAllRecentSearches = false;

  List<Map<String, dynamic>> recommendedItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.text =
        widget.initialSearchQuery ?? ''; // Initialize the search query
    searchQuery =
        widget.initialSearchQuery ?? ''; // Initialize the search query
    loadSearchHistory();
    updateRecommendedItems();
  }

  Future<void> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentSearches', recentSearches);
  }

  void addSearchQuery(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        // Reset showAllRecentSearches flag when new search query is added
        if (recentSearches.length > 3) {
          showAllRecentSearches = false;
        }
      });
      saveSearchHistory();
    }
  }

  void removeSearchQuery(int index) {
    setState(() {
      recentSearches.removeAt(index);
      // Reset showAllRecentSearches flag when search query is removed
      if (recentSearches.length <= 3) {
        showAllRecentSearches = false;
      }
    });
    saveSearchHistory();
  }

  void clearSearchHistory() {
    setState(() {
      recentSearches.clear();
      showAllRecentSearches = false;
    });
    saveSearchHistory();
  }

  void clearSearchQuery() {
    setState(() {
      _searchController.clear();
      searchQuery = '';
      updateRecommendedItems();
    });
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
      _searchController.text = query;
      updateRecommendedItems();
    });
    addSearchQuery(query);
  }

  void updateRecommendedItems() {
    Cart cart = Cart();
    List<Clother> sugProducts = cart.getClotherList();

    if (sugProducts.isNotEmpty) {
      List<Clother> filteredProducts = sugProducts.where((item) {
        return item.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();

      List<Clother> topEvaluatedItems =
          filteredProducts.where((item) => item.evaluate >= 4.5).toList();

      setState(() {
        recommendedItems = topEvaluatedItems.map((item) {
          return {
            'name': item.name,
            'image': item.imagePath,
            'product': item,
          };
        }).toList();
      });
    }
  }

  Future<void> showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          titlePadding: EdgeInsets.only(
              top: 20, left: 20, right: 20), // Adjust padding to your needs
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          title: const Text(
            'Xóa lịch sử tìm kiếm?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Toàn bộ lịch sử tìm kiếm của bạn sẽ bị xóa và không thể khôi phục được.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Hủy',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Xóa',
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                    onPressed: () {
                      clearSearchHistory();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: clearSearchQuery,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                  updateRecommendedItems();
                });
              },
              onSubmitted: (query) {
                performSearch(query);
              },
            ),
            const SizedBox(height: 10.0),
            if (recentSearches.isNotEmpty)
              const Text(
                'Lịch sử tìm kiếm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  showAllRecentSearches
                      ? recentSearches.length
                      : (recentSearches.length > 3 ? 3 : recentSearches.length),
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0), // Reduced padding
                      child: SearchHistoryItem(
                        query: recentSearches[index],
                        onDelete: () {
                          removeSearchQuery(index);
                        },
                        onTap: () {
                          performSearch(recentSearches[index]);
                        },
                      ),
                    );
                  },
                ),
                if (recentSearches.length > 3 && !showAllRecentSearches)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          showAllRecentSearches = true;
                        });
                      },
                      child: const Text('Xem thêm'),
                    ),
                  ),
                if (showAllRecentSearches)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: showDeleteConfirmationDialog,
                      child: const Text('Xóa tất cả tìm kiếm'),
                    ),
                  ),
              ],
            ),
            const Text(
              'Gợi ý tìm kiếm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: recommendedItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return SuggestedProducts(
                    sugPro: recommendedItems[index]['product'],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            detailCol: recommendedItems[index]['product'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
