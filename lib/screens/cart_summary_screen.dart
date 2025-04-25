import 'dart:convert';
import 'package:fitness/state/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CartSummaryScreen extends StatefulWidget {
  final Map<String, int> cartItems;

  CartSummaryScreen({required this.cartItems});

  @override
  State<CartSummaryScreen> createState() => _CartSummaryScreenState();
}

class _CartSummaryScreenState extends State<CartSummaryScreen> {
  List<dynamic> products = [];
  bool _orderSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = json.decode(response);
    setState(() {
      products = data;
    });
  }

  Map<String, dynamic>? _getProductDetails(String productName) {
    return products.firstWhere(
      (product) => product['name'] == productName,
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Cart Summary',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 140),
            child: Column(
              children: [
                const SizedBox(height: 60),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final productName = widget.cartItems.keys.elementAt(index);
                    final productDetails = _getProductDetails(productName);
                    final cartItems = Provider.of<CartProvider>(context).items;
                    final quantity = cartItems[productName]!;

                    if (productDetails == null) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                productDetails['images'][0],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          productName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '₹${productDetails['price']}',
                                        style: const TextStyle(
                                          color: Color(0xFF42A5F5),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            final cartProvider =
                                                Provider.of<CartProvider>(
                                                    context,
                                                    listen: false);
                                            final currentQuantity = cartProvider
                                                .getQuantity(productName);
                                            if (currentQuantity > 1) {
                                              cartProvider.updateQuantity(
                                                  productName,
                                                  currentQuantity - 1);
                                            } else {
                                              cartProvider
                                                  .removeItem(productName);
                                            }
                                          },
                                          child: const Icon(Icons.remove,
                                              size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          quantity.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            final cartProvider =
                                                Provider.of<CartProvider>(
                                                    context,
                                                    listen: false);
                                            cartProvider.updateQuantity(
                                                productName,
                                                cartProvider.getQuantity(
                                                        productName) +
                                                    1);
                                          },
                                          child:
                                              const Icon(Icons.add, size: 20),
                                        ),
                                      ],
                                    ),
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
                const SizedBox(height: 20),
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    if (widget.cartItems.isEmpty) {
                      return SizedBox
                          .shrink(); // Return an empty widget if there are no items
                    }

                    double subtotal = 0;
                    widget.cartItems.forEach((productName, _) {
                      final productDetails = _getProductDetails(productName);
                      if (productDetails != null) {
                        int quantity = cartProvider.getQuantity(productName);
                        subtotal += productDetails['price'] * quantity;
                      }
                    });
                    double tax = subtotal * 0.05;
                    double total = subtotal + tax;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _priceRow('Subtotal', subtotal),
                            const SizedBox(height: 8),
                            _priceRow('Tax (5%)', tax),
                            const Divider(height: 24),
                            _priceRow('Total', total, isBold: true),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            color: const Color(0xFFE8F0FF),
          ),
          Positioned(
            top: 0,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Transform.translate(
                  offset: const Offset(0, 60),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFD9D9D9),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "SSk",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "6,1st Avenue Street HSR Layout\n5th,Sector, Bengaluru,560034.",
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.4,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Contact-OOOOOOOOOOO",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_orderSuccess)
            AnimatedOpacity(
              opacity: _orderSuccess ? 1 : 0,
              duration: Duration(milliseconds: 500),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(24),
                          child: Icon(
                            Icons.check,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Order Placed Successfully!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _orderSuccess
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _orderSuccess = true;
                  });

                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _orderSuccess = false;
                    });
                    Provider.of<CartProvider>(context, listen: false)
                        .clearCart();
                    context.go('/');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D9BFF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Confirm and Proceed",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
    );
  }
}

Widget _priceRow(String label, double value, {bool isBold = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      Text(
        '₹${value.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ],
  );
}
