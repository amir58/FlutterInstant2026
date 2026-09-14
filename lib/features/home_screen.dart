import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigations/core/routing/routes.dart';
import 'package:navigations/features/cat.dart';
import 'package:navigations/features/products/presentation/screens/adaptive.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getCatsImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Amir Mohammed'),
              accountEmail: Text('contact@amirmohammed.com'),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('طلباتي'),
              onTap: () {
                Navigator.pop(context); // اقفل الـ Drawer الأول
                context.push('/orders'); // وبعدين انقل
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Home')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                navToProducts();
              },
              child: Text('View All Prodcuts'),
            ),

            InkWell(
              onTap: () {
                navToCities();
              },
              child: Text(
                'Select city',
                style: TextStyle(fontSize: 22),
              ),
            ),
            if (cityName != null)
              Text(
                'Selected city : $cityName',
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 18,
                ),
              ),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Add to cart'),
                    duration: Duration(milliseconds: 1500),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        print('Undo');
                      },
                    ),
                  ),
                );
              },
              child: Text('Add to cart'),
            ),
            ElevatedButton(
              onPressed: () {
                _confirmDelete();
                _confirmDeleteWay2();
                _customDialog();
              },
              child: Text('Delete from cart'),
            ),
            ElevatedButton(
              onPressed: () {
                // showBottomSheet();
                _showProductOptions();
              },
              child: Text('BottomSheet'),
            ),
            ElevatedButton(
              onPressed: () {
                toastification.show(
                  context:
                      context, // optional if you use ToastificationWrapper
                  title: Text('Hello, world!'),
                  autoCloseDuration: const Duration(seconds: 5),
                  type: ToastificationType.success,
                  style: ToastificationStyle.minimal,
                );
                toastification.show(
                  context:
                      context, // optional if you use ToastificationWrapper
                  title: Text('Hello, world!'),
                  autoCloseDuration: const Duration(seconds: 4),
                  type: ToastificationType.info,
                  style: ToastificationStyle.minimal,
                );
                toastification.show(
                  context:
                      context, // optional if you use ToastificationWrapper
                  title: Text('Hello, world!'),
                  autoCloseDuration: const Duration(seconds: 3),
                  type: ToastificationType.warning,
                  style: ToastificationStyle.minimal,
                );
                toastification.show(
                  context:
                      context, // optional if you use ToastificationWrapper
                  title: Text('Hello, world!'),
                  autoCloseDuration: const Duration(seconds: 2),
                  type: ToastificationType.error,
                  style: ToastificationStyle.minimal,
                );
              },
              child: Text('Toast'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push(Routes.counter);
              },
              child: Text('Counter Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdaptiveExample(),
                  ),
                );
              },
              child: Text('Adaptive Page'),
            ),
          ],
        ),
      ),
    );
  }

  List<CatModel> cats = [];
  Future<void> getCatsImage() async {
    final dio = Dio();

    final response = await dio.get(
      'https://api.thecatapi.com/v1/images/search?limit=10',
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonCats = response.data;

      for (var json in jsonCats) {
        CatModel catModel = CatModel.fromJson(json);
        cats.add(catModel);
      }
      setState(() {});

      print(cats.length);

      for (var cat in cats) {
        print(cat.url);
      }
    }
  }

  String? cityName;

  void navToCities() async {
    cityName = await context.push(Routes.citites);

    // cityName = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return CitiesScreen();
    //     },
    //   ),
    // );

    // if (cityName == null) {
    // return;
    // }

    // if(cityName == null) return;

    print(cityName);
    setState(() {});
  }

  void navToProducts() {
    context.push(Routes.products);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return ProductsScreen();
    //     },
    //   ),
    // );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('متأكد إنك عايز تحذف العنصر من السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('احذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // _removeFromCart(item);
    }
  }

  void _confirmDeleteWay2() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              // _removeFromCart(item);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _customDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        child: SuccessWidget(
          topRadius: true,
          mainColor: Colors.green,
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          SuccessWidget(topRadius: false, mainColor: Colors.red),
    );
  }

  Future<void> _showProductOptions() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min, // ياخد قد محتواه بس
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('مشاركة المنتج'),
                onTap: () => Navigator.pop(context, 'share'),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('أضف للمفضلة'),
                onTap: () => Navigator.pop(context, 'favorite'),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text('أضف للسلة'),
                onTap: () => Navigator.pop(context, 'cart'),
              ),
            ],
          ),
        ),
      ),
    );

    if (action == 'cart') {
      // _addToCart();
    }
  }
}

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({
    super.key,
    required this.topRadius,
    required this.mainColor,
  });

  final bool topRadius;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.only(
              topRight: Radius.circular(topRadius ? 20 : 0),
              topLeft: Radius.circular(topRadius ? 20 : 0),
            ),
            color: mainColor,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 33,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Success',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Your order places success, we will contact you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: mainColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
            ),
            child: Text('Ok', style: TextStyle(color: mainColor)),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
