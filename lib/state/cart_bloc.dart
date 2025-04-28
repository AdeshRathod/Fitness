import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  AddToCart(this.productId);
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

// State
abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<String> cartItems;
  CartUpdated(this.cartItems);
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  final List<String> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<AddToCart>((event, emit) {
      _cartItems.add(event.productId);
      emit(CartUpdated(List.from(_cartItems)));
    });

    on<RemoveFromCart>((event, emit) {
      _cartItems.remove(event.productId);
      emit(CartUpdated(List.from(_cartItems)));
    });
  }
}
