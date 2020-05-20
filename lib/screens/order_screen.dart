import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart' show Orders;
import 'package:my_shop/widgets/main_drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';


class OrderScreen extends StatelessWidget {

static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot){
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else{
            if(dataSnapshot.error != null){
              //error Handling
              return Center(child: Text('An error occur'),);
            } else{
              return Consumer<Orders>(
                builder: (ctx,orderData,_) =>
                  ListView.builder(
                   itemCount: orderData.orders.length ,
                   itemBuilder: (ctx, i) => 
                   OrderItem(orderData.orders[i]),
                )
              ,) ;
            }
          }

        },
      ),
      drawer: MainDrawer(),
    );
  }
}