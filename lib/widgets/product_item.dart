import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {


  void goToDetailPage(BuildContext context, Product prod){
    Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: prod.id,
    );
  }
  @override
  Widget build(BuildContext context) {
    
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
          child: GestureDetector(
            onTap: () =>goToDetailPage(context,product),
            child: Image.network(product.imageUrl,fit: BoxFit.cover)),
          footer: GridTileBar(
          backgroundColor: Colors.black87,

          leading: Consumer<Product>(
            builder: (ctx, product, _) => 
             IconButton(
              icon: Icon(product.isFavourite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: (){
              product.toggleFavourite();
            },),  
          ),
          title: Text(product.title,textAlign: TextAlign.center,),  
          trailing: IconButton(icon: Icon(Icons.shopping_cart),
          color: Theme.of(context).accentColor,
          onPressed: (){
            cart.addItem(product.id, product.title, product.price);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Added item to cart!'),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: (){
                  cart.removeSingleItem(product.id);
                },
              ),
            ));
          },),
          ),
        ),
    );
  }
} 