import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navigations/features/cart/data/models/cart_model.dart';
import 'package:toastification/toastification.dart';

class CartProductItem extends StatefulWidget {
  const CartProductItem({
    super.key,
    required this.product,
    required this.onQunatityChanged,
  });

  final CartProductModel product;
  final Function(int productId, int quantity) onQunatityChanged;

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 20,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,

                        imageUrl: widget.product.thumbnail,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(5),

                      child: Text(
                        '${widget.product.discountPercentage.toInt()}% OFF',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('10.5-inch • 64GB • White'),
                      SizedBox(height: 5),
                      FittedBox(
                        child: Row(
                          spacing: 10,
                          children: [
                            Text(
                              '\$${widget.product.total}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '\$${widget.product.discountedTotal}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                                decorationColor: Colors.grey,
                                decoration:
                                    TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${widget.product.price} / unit'),
                // Spacer(),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            if (widget.product.quantity == 1) {
                              toastification.show(
                                context: context,
                                title: Text(
                                  'Min quantity per order is : 1',
                                ),
                                type: ToastificationType.info,
                              );
                              return;
                            }

                            setState(() {
                              widget.product.quantity--;
                            });

                            widget.onQunatityChanged.call(
                              widget.product.id,
                              widget.product.quantity,
                            );
                          },
                          icon: Icon(Icons.remove),
                        ),
                      ),
                      Text(
                        widget.product.quantity.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            if (widget.product.quantity ==
                                widget.product.maxQuantityPerOrder) {
                              toastification.show(
                                context: context,
                                title: Text(
                                  'Max quantity per order is : ${widget.product.maxQuantityPerOrder}',
                                ),
                                type: ToastificationType.info,
                              );
                              return;
                            }

                            setState(() {
                              widget.product.quantity++;
                            });

                            widget.onQunatityChanged(
                              widget.product.id,
                              widget.product.quantity,
                            );
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
