
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier{
  List<Product> _items = [
  
    // Product(
    //   id: 'p1',
    //   title: 'IPhone 8',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://www.imangoss.net/wp-content/uploads/2018/02/best-wallpaper-for-iphone-min.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'IPhone 5s',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://www.itl.cat/pngfile/big/7-72889_iphone-5s-wallpapers-hd-desktop-hd-iphone-5.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'IPhone X',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://i.ytimg.com/vi/OdjBOXUffq0/maxresdefault.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Apple AirPod',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://i.pcmag.com/imagery/articles/02zGwwu8hay4RsVbi2ngn5E-2.fit_scale.size_2698x1517.v1569490256.jpg',
    // ),
     
];

  
  
  List<Product> get items{
    
    return _items;
  }

  List<Product> get favouriteItems{
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id){
    return items.firstWhere((prod) => prod.id == id );
  }

  Future<void> fetchandSetProducts() async {
    const url = 'https://myshopdatabase-abb5c.firebaseio.com/products.json';
    try{
      final response = await http.get(url);
       final extractedData = json.decode(response.body) as Map<String, dynamic>;
       final List<Product> loadedProducts = [];
       extractedData.forEach((prodId, prodData) { 
         loadedProducts.add(
           Product(
             id: prodId,
             title: prodData['title'],
             description: prodData['description'],
             price: prodData['price'],
             isFavourite: prodData['isFavourite'],
             imageUrl: prodData['imageUrl']
           )
         );
       });
       _items = loadedProducts;
       notifyListeners();
    }catch (error){
      throw(error);
    }   
  
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://myshopdatabase-abb5c.firebaseio.com/products.json';
    try{
    final response = await http.post(url, body: json.encode(
      {
        'title' : product.title,
        'description' : product.description,
        'imageUrl' : product.imageUrl,
        'price' : product.price,
        'isFavourite' : product.isFavourite
      }
    ));
    
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: json.decode(response.body)['name'],
    );
      _items.add(newProduct);
    notifyListeners();
    }catch(error){
      print('Error');
      throw(error);
    }
  }

  Future<void> updateProduct (String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if(prodIndex >= 0){
      final url = 'https://myshopdatabase-abb5c.firebaseio.com/products/$id.json';
      http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }else{
      print('.....');
    }
  }
  
  Future<void> deleteProduct (String id) async{
    final url = 'https://myshopdatabase-abb5c.firebaseio.com/products/$id.json';
    final existingproductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingproductIndex];
    _items.removeAt(existingproductIndex);
    notifyListeners();

    final response = await http.delete(url);
      if(response.statusCode >=400){

      _items.insert(existingproductIndex, existingProduct);
      notifyListeners();

        throw HttpException('Could not delete Product');
      }
    existingProduct = null;
    
      }
}