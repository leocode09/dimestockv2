import 'package:Leonidas/stock/_product.dart';
import 'package:intl/intl.dart';
// import 'package:Leonidas/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> saveProducts(List products) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
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
              stock: (item['stock'] as List)
                  .map((e) => List<int>.from(e))
                  .toList(),
            ))
        .toList();
  } else {
    return [
      Product(
        name: "Test",
        date: DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(Duration(days: 7))),
        costPrice: 10.0,
        sellingPrice: 15.0,
        stock: [
          [0, 0],
        ],
      ),
    ];
  }
}
