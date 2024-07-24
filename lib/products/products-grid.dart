
import 'package:Leonidas/stock/_product.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;

  const ProductsGrid({Key? key, required this.products}) : super(key: key);

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
                color: Colors.green,
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
                crossAxisCount: 3,
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
              style: TextStyle(color: Colors.green, fontSize: 14),
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
            Icon(Icons.add, color: Colors.green, size: 40),
            SizedBox(height: 8),
            Text(
              'Add New',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example:
// ProductsGrid(products: yourProductsList)