import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData  = Provider.of<ProductProvider>(context);
    final products = productsData.items;

    return SizedBox(
            height: 160,
            width: 300,
            child: Carousel(
            boxFit: BoxFit.cover,
            autoplay: true,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 1000),
            dotSize: 4,       
            dotIncreasedColor: Colors.black,
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            // borderRadius: true,
            dotVerticalPadding: 10.0,
            showIndicator: true,
            indicatorBgPadding: 7,
            images: products.map((e) => NetworkImage(e.imageUrl)).toList()           
            ),
          );
  }
}