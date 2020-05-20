import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart' show Cart;
import 'package:my_shop/providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                                 Text('Total',style: TextStyle(fontSize: 20),),
                                    SizedBox(width: 10,),
                            Chip(label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',style: TextStyle(
                    // color: Theme.of(context).primaryTextTheme.title.color,
                  ),)
                  ,backgroundColor: Theme.of(context).primaryColor,
                  ),

                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.item.length,
              itemBuilder: (ctx , index) =>
              CartItem(
                cart.item.values.toList()[index].id,
                cart.item.values.toList()[index].price,
                cart.item.values.toList()[index].quantity,
                cart.item.values.toList()[index].title,
                cart.item.keys.toList()[index]
              ),
            ),
          )
        ],
      )
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null  : () async{
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.item.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
    );
  }
}