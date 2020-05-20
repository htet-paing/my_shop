import 'package:flutter/material.dart';
import 'package:my_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';


   
class ProductDetailScreen extends StatelessWidget {
    static const routeName = '/productDetail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productData = Provider.of<ProductProvider>(context).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail page'),      
      ),
      body: Column(
        children: <Widget>[

        Padding(
          padding: EdgeInsets.all(8),
          child: Text(productData.title),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(productData.description),
        ),
        ],
      ),
    );
  }
}