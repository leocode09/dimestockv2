class Product {
  String name;
  String date;
  int costPrice;
  int sellingPrice;
  List<List<int>> stock;

  Product({
    required this.name,
    required this.date,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
  });

  // Product updateStock() {
  //   return Product(
  //     name: name,
  //     date: date,
  //     costPrice: costPrice,
  //     sellingPrice: sellingPrice,
  //     stock: ,
  //   );
  // }
}
