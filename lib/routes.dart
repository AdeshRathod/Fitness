import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'state/cart_bloc.dart';
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
        return BlocProvider.value(
          value: BlocProvider.of<CartBloc>(context),
          child: CartScreen(),
        );
      },
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) {
        return BlocProvider.value(
          value: BlocProvider.of<CartBloc>(context),
          child: CartSummaryScreen(),
        );
      },
    ),
  ],
);
