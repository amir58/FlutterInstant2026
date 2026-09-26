import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/widgets/overlay_loading.dart';
import 'package:navigations/features/cart/data/models/cart_model.dart';
import 'package:navigations/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:navigations/features/cart/presentation/widgets/cart_product_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is UpdateCartLoadingState) {
          LoadingOverlay.show(context);
        } else {
          LoadingOverlay.hide();
        }
      },
      buildWhen: (previous, current) => current is CartLoadedState,
      builder: (context, state) {
        return Scaffold(
          appBar: CartAppBar(
            viewDeleteCart: state is CartLoadedState,
          ),
          bottomNavigationBar: state is CartLoadedState
              ? CartProceedButton()
              : SizedBox.shrink(),

          body: state is CartLoadedState
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: [
                        CartItemsSection(
                          itemsCount: state.cart.totalQuantity,
                        ),

                        CartProductsList(
                          products: state.cart.products,
                        ),
                        CartOrderSummary(
                          itemsCount: state.cart.totalQuantity,
                          subTotal: state.cart.total,
                          discountSaving: state.cart.discountedTotal,
                          totalDue:
                              state.cart.total -
                              state.cart.discountedTotal,
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class CartProductsList extends StatelessWidget {
  const CartProductsList({super.key, required this.products});

  final List<CartProductModel> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        debugPrint('Index => $index');

        final product = products[index];

        return CartProductItem(
          product: product,
          onQunatityChanged: (int productId, int quantity) {
            context.read<CartCubit>().updateQuntity(
              productId: productId,
              quantity: quantity,
            );
          },
        );
      },
    );
  }
}

class CartOrderSummary extends StatelessWidget {
  const CartOrderSummary({
    super.key,
    required this.itemsCount,
    required this.subTotal,
    required this.discountSaving,
    required this.totalDue,
  });

  final int itemsCount;
  final double subTotal;
  final double discountSaving;
  final double totalDue;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal ($itemsCount items)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.75),
                  ),
                ),
                Text(
                  '\$${subTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Discount Savings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.lightGreen,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(2.5),
                  margin: EdgeInsetsDirectional.only(start: 5),
                  child: Text(
                    'Promo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '-\$$discountSaving',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.75),
                  ),
                ),
                Text(
                  'Free',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Tax',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.75),
                  ),
                ),
                Text(
                  '\$0.00',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Due',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '\$${totalDue.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Including all applied discounts',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartProceedButton extends StatelessWidget {
  const CartProceedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ElevatedButton.icon(
        onPressed: () {},
        label: Text(
          'Proceed to Checkout',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.arrow_forward_rounded, color: Colors.white),
        iconAlignment: IconAlignment.end,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}

class CartItemsSection extends StatelessWidget {
  const CartItemsSection({super.key, required this.itemsCount});

  final int itemsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Text(
          'Cart Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(5),

          child: Text(
            '$itemsCount items',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              // color: Colors.white,
            ),
          ),
        ),
        Spacer(),
        Icon(Icons.bookmark_outline, color: Colors.indigo),
        Text(
          'Save all for later',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.indigo,
          ),
        ),
      ],
    );
  }
}

class CartAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CartAppBar({super.key, required this.viewDeleteCart});

  final bool viewDeleteCart;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Cart'),
      centerTitle: true,
      actions: [
        Visibility(
          visible: viewDeleteCart,
          child: IconButton(
            onPressed: () {
              _confirmDelete(context);
            },
            icon: Icon(Icons.delete_outlined),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete cart'),
            content: const Text('Are you sure to delete cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed && context.mounted) {
      context.read<CartCubit>().deleteCart();
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
