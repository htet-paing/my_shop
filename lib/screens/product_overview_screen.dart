import 'package:flutter/material.dart';
import 'package:my_shop/auth/authentication.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product_provider.dart';
import 'package:my_shop/widgets/badge.dart';
import 'package:my_shop/widgets/main_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/product_carousel.dart';
import '../widgets/product_grid.dart';
import 'cart_screen.dart';

enum FilterOptions{
  Favourites,
  All,
  Logout,
}

class ProductsOverviewScreen extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  ProductsOverviewScreen({this.auth, this.logoutCallback, this.userId});

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavouriteOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) => 
    // Provider.of<ProductProvider>(context).fetchandSetProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
    Provider.of<ProductProvider>(context).fetchandSetProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    }catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[  
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                if(selectedValue == FilterOptions.Favourites){
                _showFavouriteOnly = true;
              }else if (selectedValue == FilterOptions.All) {
                _showFavouriteOnly = false;
              }else {
                signOut();
              }
              });      
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
            PopupMenuItem(child: Text('Only Favourites'), value: FilterOptions.Favourites,),
            PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,),
            PopupMenuItem(child: Text('Log out'),value: FilterOptions.Logout,)
            ],
          ),
          Consumer<Cart>(
             builder: (_, cart, ch) =>
             Badge(
            child: ch,
            value: cart.itemsCount.toString() ,
          ) ,
          child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body:  _isLoading ? Center(child: CircularProgressIndicator(),) : ListView(
        children: <Widget>[
          ProductCarousel(),
          ProductGrid(_showFavouriteOnly),
       ], 
      ),
      drawer: MainDrawer(),
    );
  }
}

