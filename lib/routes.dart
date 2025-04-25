import 'package:go_router/go_router.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/cart_summary_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ProductListScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) {
        final product = state.extra as Map<String, dynamic>;
        return ProductDetailsScreen(product: product);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) {
        final cartItems = state.extra as Map<String, int>? ?? {};
        return CartScreen(cartItems: cartItems);
      },
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) {
        final cartItems = state.extra as Map<String, int>? ?? {};
        return CartSummaryScreen(cartItems: cartItems);
      },
    ),
  ],
);
