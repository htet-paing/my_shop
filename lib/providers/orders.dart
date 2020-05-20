
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
  

}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return _orders;
  }
  Future<void> fetchAndSetOrders() async{
    const url = 'https://myshopdatabase-abb5c.firebaseio.com/orders.json';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return ;
    }
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) => 
          CartItem(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quality']
          )).toList()
        )
      );
     });
     _orders = loadedOrders.reversed.toList();
     notifyListeners();
  }


  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://myshopdatabase-abb5c.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response =await http.post(url, body: json.encode({
      'amount' : total,
      'dateTime' : timeStamp.toIso8601String(),
      'products' : cartProducts.map((cp) => {
        'id' : cp.id,
        'title': cp.title,
        'quantity' : cp.quantity,
        'price' : cp.price
        
      }).toList()
    })
    );
    _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      products: cartProducts, 
      dateTime: DateTime.now(),));
    notifyListeners();
  }

}