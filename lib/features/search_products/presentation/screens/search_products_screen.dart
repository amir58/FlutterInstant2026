import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigations/features/products/data/models/product_model.dart';
import 'package:navigations/features/products/presentation/cubit/products_cubit.dart';
import 'package:navigations/features/products/presentation/widgets/product_item.dart';
import 'package:navigations/features/search_products/presentation/cubit/search_products_cubit.dart';
import 'package:shimmer/shimmer.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() =>
      _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  late final SearchProductsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SearchProductsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            _searchController.clear();
            context.pop();
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          onChanged: (query) {
            // Run your filter logic here
            cubit.onQueryChanged(query);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
      ),
      body: BlocBuilder<SearchProductsCubit, SearchProductsState>(
        builder: (context, state) {
          switch (state) {
            case SearchProductsInitialState():
              return SizedBox();

            case SearchProductsLoadingState():
              return ProductShimmer();

            case SearchProductsEmptyState():
              return ProductsEmpty();

            case SearchProductsSuccessState():
              return ProductsList(
                products: state.products,
                isLoadingMore: state.isLoadingMore,
              );

            case SearchProductsFailureState():
              return ProductsFailure();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            height: 450,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }
}

class ProductsFailure extends StatelessWidget {
  const ProductsFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, size: 88),
          Text(
            (context.read<ProductsCubit>().state
                    as ProductsFailureState)
                .message, // استخدمه بحرص شديد
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

class ProductsList extends StatefulWidget {
  const ProductsList({
    super.key,
    required this.products,
    required this.isLoadingMore,
  });

  final List<Products> products;
  final bool isLoadingMore;

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          widget.products.length + (widget.isLoadingMore ? 1 : 0),

      itemBuilder: (context, index) {
        if (index >= widget.products.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        //                     0 .. 19 |  20
        final product = widget.products[index];

        return ProductItem(product: product);
      },
    );
  }
}

class ProductsEmpty extends StatelessWidget {
  const ProductsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.data_array, size: 88),
          Text('No prodcuts found!', style: TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}
