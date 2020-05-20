import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';
import '../providers/product_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;

  ProductGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final productsData  = Provider.of<ProductProvider>(context);
    final products = showFav ? productsData.favouriteItems : productsData.items;

    return Container(
      height: 500,
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(          
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10, 
        maxCrossAxisExtent: 200,
        ), 
        itemBuilder: (context, index) => 
        ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        ) 
      ),
    );
  }
}