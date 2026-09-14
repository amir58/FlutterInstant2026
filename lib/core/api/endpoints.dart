class EndPoints {
  EndPoints._();

  static const String baseUrl = 'https://dummyjson.com';

  static const String login = '/auth/login';

  // products
  static const String products = '/products';

  static String productDetails(int productId) =>
      '/products/$productId';

  static const String searchProducts = '/products/search';
  static String productById(int id) => '/products/$id';

  static const String productsSearch = '/products/search';

  static const String categories = '/products/categories';
  static String productsByCategory(String slug) =>
      '/products/category/$slug';

  static const String cart = '/carts';

  static const String addToCart = '/carts/add';

  static const String addProduct = '/products/add';
}
