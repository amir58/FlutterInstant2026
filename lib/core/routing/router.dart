import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:navigations/core/api/dio_factory.dart';
import 'package:navigations/core/database/db.dart';
import 'package:navigations/core/routing/routes.dart';
import 'package:navigations/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:navigations/features/cart/data/repositories/cart_repo.dart';
import 'package:navigations/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:navigations/features/cart/presentation/pages/cart_page.dart';
import 'package:navigations/features/cities_screen.dart';
import 'package:navigations/features/counter/cubit/counter_cubit.dart';
import 'package:navigations/features/counter/pages/counter_page.dart';
import 'package:navigations/features/expenses/data/datasources/expenses_local_data_source.dart';
import 'package:navigations/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:navigations/features/expenses/domain/usecases/get_categories_usecase.dart';
import 'package:navigations/features/expenses/domain/usecases/get_month_overview_usecase.dart';
import 'package:navigations/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:navigations/features/expenses/presentation/pages/expenses_page.dart';
import 'package:navigations/features/home_screen.dart';
import 'package:navigations/features/login/data/data_sources/auth_datasource.dart';
import 'package:navigations/features/login/data/data_sources/token_local_datasource.dart';
import 'package:navigations/features/login/data/repo/auth_repo.dart';
import 'package:navigations/features/login/presentation/cubit/login_cubit.dart';
import 'package:navigations/features/login/presentation/pages/login_screen.dart';
import 'package:navigations/features/maps/map_sample.dart';
import 'package:navigations/features/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:navigations/features/product_details/data/repositories/product_details_repo.dart';
import 'package:navigations/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:navigations/features/product_details/presentation/pages/product_details_screen.dart';
import 'package:navigations/features/products/data/data_sources/products_remote_data_source.dart';
import 'package:navigations/features/products/data/repo/products_repo.dart';
import 'package:navigations/features/products/presentation/cubit/products_cubit.dart';
import 'package:navigations/features/products/presentation/screens/products_screen.dart';
import 'package:navigations/features/search_products/data/data_sources/search_products_remote_data_source.dart';
import 'package:navigations/features/search_products/data/repo/search_products_repo.dart';
import 'package:navigations/features/search_products/presentation/cubit/search_products_cubit.dart';
import 'package:navigations/features/search_products/presentation/screens/search_products_screen.dart';
import 'package:navigations/features/upload/presentation/cubit/upload_cubit.dart';
import 'package:navigations/features/upload/presentation/pages/upload_screen.dart';

final router = GoRouter(
  // initialLocation: '/',
  // initialLocation: Routes.home,
  initialLocation: Routes.expenses,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit(
          AuthRepo(
            AuthRemoteDataSource(DioFactory.getDio()),
            TokenLocalDataSource(FlutterSecureStorage()),
          ),
        ),
        child: LoginScreen(),
      ),
    ),
    GoRoute(
      path: Routes.expenses,
      builder: (context, state) => BlocProvider(
        create: (context) => ExpensesCubit(
          GetCategoriesUseCase(
            ExpensesRepositoryImpl(
              ExpensesLocalDataSourceImpl(DatabaseHelper()),
            ),
          ),
          GetMonthOverviewUseCase(
            ExpensesRepositoryImpl(
              ExpensesLocalDataSourceImpl(DatabaseHelper()),
            ),
          ),
        ),
        child: ExpensesPage(),
      ),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: Routes.products,
      builder: (context, state) => BlocProvider(
        create: (context) => ProductsCubit(
          ProductsRepo(ProductsRemoteDataSource(DioFactory.getDio())),
        ),
        child: ProductsScreen(),
      ),
    ),
    GoRoute(
      path: Routes.searchProducts,
      builder: (context, state) => BlocProvider(
        create: (context) => SearchProductsCubit(
          SearchProductsRepo(
            SearchProductsRemoteDataSource(DioFactory.getDio()),
          ),
        ),
        child: SearchProductsScreen(),
      ),
    ),
    GoRoute(
      path: Routes.productDetails,
      builder: (context, state) {
        final productId = state.extra as int;

        return BlocProvider(
          create: (context) => ProductDetailsCubit(
            ProductDetailsRepo(
              ProductDetailsRemoteDataSource(DioFactory.getDio()),
            ),
          ),
          child: ProductDetailsScreen(productId: productId),
        );
      },
    ),
    GoRoute(
      path: Routes.citites,
      builder: (context, state) => CitiesScreen(),
    ),
    GoRoute(
      path: Routes.counter,
      builder: (context, state) => BlocProvider(
        create: (context) => CounterCubit(),
        child: CounterPage(),
      ),
    ),

    GoRoute(
      path: Routes.cart,
      builder: (context, state) => BlocProvider(
        create: (context) => CartCubit(
          CartRepo(CartRemoteDataSource(DioFactory.getDio())),
        ),
        child: CartScreen(),
      ),
    ),

    GoRoute(
      path: Routes.upload,
      builder: (context, state) => BlocProvider(
        create: (context) => UploadCubit(),
        child: UploadScreen(),
      ),
    ),

    GoRoute(
      path: Routes.mapSample,
      builder: (context, state) => MapSample(),
    ),
  ],
);
