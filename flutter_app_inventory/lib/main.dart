import 'package:flutter/material.dart';
import 'package:flutter_app_inventory/pages/add_new_product.dart';
import 'package:flutter_app_inventory/pages/master_product_page.dart';
import 'package:provider/provider.dart';

import './pages/product_page.dart';
import './providers/products.dart';

import './pages/master_product_page.dart';
import './pages/add_new_product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // load provider Products
        ChangeNotifierProvider.value(
          value: Products(),
        ),
//        ChangeNotifierProvider.value(
//          value: ProviderLain(),
//        ),
      ],
      child: MaterialApp(
        title: 'Agetory',
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.orange,
          accentColor: Colors.deepOrange
        ),
        routes: {
          '/': (ctx) => ProductPage(),
          '/manage-product': (ctx) => MasterProductPage(),
          '/add-product': (ctx) => AddNewProduct()
        },
      )
    );
  }
}
