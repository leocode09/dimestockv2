class Product {
  final String name;
  final String date;
  final int costPrice;
  final int sellingPrice;
  final int stock0;
  final int stock1;
  int stock2;

  Product({
    required this.name,
    required this.date,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock0,
    required this.stock1,
    required this.stock2,
  });

  Product updateStock() {
    return Product(
      name: name,
      date: date,
      costPrice: costPrice,
      sellingPrice: sellingPrice,
      stock0: stock1,
      stock1: stock2,
      stock2: 0,
    );
  }
}
