import 'package:flutter/material.dart';
import 'package:my_shop/root_page.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:my_shop/screens/order_screen.dart';
import 'package:my_shop/screens/user_product_screen.dart';
import './providers/product_provider.dart';
import './screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'package:my_shop/auth/authentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductProvider(),
        ),

        ChangeNotifierProvider.value(
          value: Cart(),
        ),

        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'
          
        ),
        initialRoute: '/',
        routes: {
          '/' : (ctx) => RootPage(auth: Auth()),
          ProductDetailScreen.routeName : (ctx) => ProductDetailScreen(),
          CartScreen.routeName : (ctx) => CartScreen(),
          OrderScreen.routeName : (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen()
          
        },
      )
    );          
  }
}

