import 'package:dimestockv2/_product.dart';
import 'package:dimestockv2/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveProducts() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final productsJson = products
      .map((product) => {
            'name': product.name,
            'date': product.date,
            'costPrice': product.costPrice,
            'sellingPrice': product.sellingPrice,
            'stock': product.stock,
          })
      .toList();
  await prefs.setString('products', jsonEncode(productsJson));
}

Future<List<Product>> loadProducts() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final productsJson = prefs.getString('products');

  if (productsJson != null) {
    final decodedProducts = jsonDecode(productsJson) as List;
    return decodedProducts
        .map((item) => Product(
              name: item['name'],
              date: item['date'],
              costPrice: item['costPrice'],
              sellingPrice: item['sellingPrice'],
              stock: item['stock'],
            ))
        .toList();
  } else {
    // Handle the case where there's no saved product data (optional)
    return []; // Or an empty list if no products are saved
  }
}
