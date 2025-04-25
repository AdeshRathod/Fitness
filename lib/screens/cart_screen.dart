import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/cart_provider.dart';

class CartScreen extends StatefulWidget {
  final Map<String, int> cartItems;

  CartScreen({required this.cartItems});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> products = [];

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
    final cartItems = Provider.of<CartProvider>(context).items;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: cartItems.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.go('/');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Icon(Icons.add, size: 16),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Add products to cart',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: Icon(Icons.mic_none),
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.cartItems.length + 1,
                          itemBuilder: (context, index) {
                            if (index == widget.cartItems.length) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 4.0,
                                    bottom: 12.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.go('/');
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black54),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Icon(Icons.add, size: 16),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Add more products',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            final productName =
                                widget.cartItems.keys.elementAt(index);
                            final quantity = widget.cartItems[productName]!;
                            final productDetails =
                                _getProductDetails(productName);

                            if (productDetails == null) {
                              return SizedBox.shrink();
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
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '₹${productDetails['price']}',
                                                style: TextStyle(
                                                  color: Color(0xFF42A5F5),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        final cartProvider =
                                                            Provider.of<
                                                                    CartProvider>(
                                                                context,
                                                                listen: false);
                                                        final currentQuantity =
                                                            cartProvider
                                                                .getQuantity(
                                                                    productName);
                                                        if (currentQuantity >
                                                            1) {
                                                          cartProvider
                                                              .updateQuantity(
                                                                  productName,
                                                                  currentQuantity -
                                                                      1);
                                                        } else {
                                                          cartProvider
                                                              .removeItem(
                                                                  productName);
                                                        }
                                                      },
                                                      child: Icon(Icons.remove,
                                                          size: 20),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      quantity.toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(width: 8),
                                                    GestureDetector(
                                                      onTap: () {
                                                        final cartProvider =
                                                            Provider.of<
                                                                    CartProvider>(
                                                                context,
                                                                listen: false);
                                                        cartProvider.updateQuantity(
                                                            productName,
                                                            cartProvider.getQuantity(
                                                                    productName) +
                                                                1);
                                                      },
                                                      child: Icon(Icons.add,
                                                          size: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(217, 217, 217, 0.31),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rent Cost Breakup',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ...cartItems.keys.map((productName) {
                                  int index = cartItems.keys
                                          .toList()
                                          .indexOf(productName) +
                                      1;
                                  final productDetails =
                                      _getProductDetails(productName);
                                  if (productDetails == null)
                                    return SizedBox.shrink();

                                  double rentalCost = 187.00;
                                  double rentoCare = 39.68;
                                  double itemPrice =
                                      (productDetails['price'] as num)
                                          .toDouble();
                                  double totalTenureCost =
                                      rentalCost + rentoCare + itemPrice;

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$index. $productName',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 6),
                                        _rentRow('(A) Rental Cost',
                                            '₹${rentalCost.toStringAsFixed(2)}/mo'),
                                        SizedBox(height: 2),
                                        _rentRow('(B) Rento Care',
                                            '₹${rentoCare.toStringAsFixed(2)}/mo'),
                                        SizedBox(height: 2),
                                        _rentRow(
                                            '(C) Selected Tenure', '1 month'),
                                        SizedBox(height: 2),
                                        _rentRow('(D) Total Tenure Cost',
                                            '₹${totalTenureCost.toStringAsFixed(2)}'),
                                        SizedBox(height: 6),
                                        Text(
                                          'You will save ₹645.60',
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        if (index != cartItems.keys.length &&
                                            cartItems.keys.length >= 2) ...[
                                          SizedBox(height: 10),
                                          const DottedLine(
                                            dashLength: 3,
                                            dashColor:
                                                Color.fromRGBO(93, 155, 255, 1),
                                            lineThickness: 1,
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        if (cartItems.keys.length == 1) SizedBox(height: 300),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.push('/summary', extra: cartProvider.items);
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

Widget _rentRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 1)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );
}
