import 'dart:async';
import 'dart:convert';
import 'package:fitness/state/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List products = [];
  late Timer _timer;
  int _currentImageIndex = 0;
  // late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchQuery = "";
  List _allProducts = [];
  String _selectedCategory = "Basic"; // default

  final List<String> categories = [
    "Basic",
    "Fitness",
    "Appliances",
    "Furniture"
  ];

  @override
  void initState() {
    super.initState();
    // _speech = stt.SpeechToText();
    _tabController = TabController(length: categories.length, vsync: this);
    loadProducts();
    startImageRotation();
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);
    setState(() {
      products = data;
      _allProducts = data;
      _filterProductsByCategory(_selectedCategory);
    });
  }

  void startImageRotation() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % 3;
      });
    });
  }

  // void _startListening() async {
  //   bool available = await _speech.initialize();
  //   if (available) {
  //     setState(() => _isListening = true);
  //     _speech.listen(onResult: (val) {
  //       setState(() {
  //         _searchQuery = val.recognizedWords;
  //       });
  //     });
  //   }
  // }

  // void _stopListening() {
  //   setState(() => _isListening = false);
  //   _speech.stop();
  // }

  void _filterProductsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      products = _allProducts.where((product) {
        final prodCategory = product['category'];
        return prodCategory != null && prodCategory == category;
      }).toList();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Fitness',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final cartCount = cartProvider.items.values
                  .fold<int>(0, (sum, quantity) => sum + quantity);

              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'assets/icons/cart.png',
                      height: 24,
                      width: 24,
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -10,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            cartCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  context.push('/cart', extra: cartProvider.items);
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print("Mic icon tapped");
                      // _isListening ? _stopListening() : _startListening();
                    },
                    child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(categories.length, (index) {
                  final isSelected = _tabController.index == index;
                  return GestureDetector(
                    onTap: () {
                      _tabController.animateTo(index);
                      _filterProductsByCategory(categories[index]);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: _allProducts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : products.isEmpty
                      ? Center(
                          child: Text(
                            "No products listed in this category as of now.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : GridView.builder(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            if (_searchQuery.isNotEmpty &&
                                !product['name']
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase())) {
                              return SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () {
                                GoRouter.of(context)
                                    .push('/details', extra: product);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFF999595), width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: Image.asset(
                                        '${product['images'][_currentImageIndex % product['images'].length]}',
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    if (product['images'].length > 1)
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                              product['images'].length,
                                              (dotIndex) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: dotIndex ==
                                                        _currentImageIndex %
                                                            product['images']
                                                                .length
                                                    ? Colors.black
                                                    : Colors.grey.shade300,
                                                shape: BoxShape.circle,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    Divider(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "₹${product['price']} / month",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(height: 4),
                                          if (product['oldPrice'] != null &&
                                              product['discount'] != null)
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    "-${product['discount']}%",
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  "₹${product['oldPrice']}/mo",
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 13,
                                                    color: Color(0xFF999595),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Delivery by ${product['delivery']}",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sort, color: Colors.grey),
                          SizedBox(height: 4),
                          Text(
                            'Sort',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Color(0xFF999595),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_alt_outlined, color: Colors.grey),
                          SizedBox(height: 4),
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
