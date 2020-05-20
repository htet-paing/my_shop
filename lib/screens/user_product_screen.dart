import 'package:flutter/material.dart';
import 'package:my_shop/widgets/main_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

import 'edit_product_screen.dart';
class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product';
  
  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<ProductProvider>(context).fetchandSetProducts();
  }
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (_, i) =>
            Column(children: <Widget>[
              UserProductItem(
                 id: productData.items[i].id,
                 title: productData.items[i].title,
                 imageUrl: productData.items[i].imageUrl,
              ),
              Divider()
            ],)
          ),
        ),
      ),
      drawer: MainDrawer(),
    );
  }
}