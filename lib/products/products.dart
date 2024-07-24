import 'package:Leonidas/stock/_product.dart';
import 'package:Leonidas/stock/products.dart';
import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  // final List<Product> products;
// final List<Product> products

// In your build method:
// ProductsGrid(products: products)
  // const Products({Key? key, required this.products}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String _searchQuery = '';

  List<Product> get filteredProducts {
  if (_searchQuery.isEmpty) {
    return products;
  }
  return products.where((product) =>
    product.name.toLowerCase().contains(_searchQuery.toLowerCase())
  ).toList();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products (${products.length})',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage products for your store',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ...products.map((product) => _buildProductCard(product)),
                  _buildAddNewCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      color: Color(0xFF1A1A1A),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cable_outlined, color: Colors.white, size: 40),
            SizedBox(height: 8),
            Text(
              product.name,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '\$ ${product.sellingPrice.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.orange, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCard() {
    return Card(
      color: Color(0xFF1A1A1A),
      child: InkWell(
        onTap: () {
          // Add new product functionality
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.orange, size: 40),
            SizedBox(height: 8),
            Text(
              'Add New',
              style: TextStyle(color: Colors.orange, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example:
// ProductsGrid(products: yourProductsList)