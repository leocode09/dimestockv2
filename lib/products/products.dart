import 'dart:ui';
import 'dart:math' as math;
import 'package:Leonidas/stock/_product.dart';
import 'package:Leonidas/stock/products.dart';
import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String _searchQuery = '';
  Map<Product, int> _cartItems = {};

  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return products;
    }
    return products.where((product) =>
      product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      product.sellingPrice.toString().contains(_searchQuery) 
      // product.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void _addToCart(Product product) {
    setState(() {
      if (_cartItems.containsKey(product)) {
        _cartItems[product] = _cartItems[product]! + 1;
      } else {
        _cartItems[product] = 1;
      }
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      if (_cartItems.containsKey(product)) {
        if (_cartItems[product]! > 1) {
          _cartItems[product] = _cartItems[product]! - 1;
        } else {
          _cartItems.remove(product);
        }
      }
    });
  }
 void _showSellsPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: NoisePainter(),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sells Page',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: ListView(
                              children: _cartItems.entries.map((entry) {
                                return ListTile(
                                  title: Text(entry.key.name, style: TextStyle(fontSize: 18, color: Colors.white)),
                                  subtitle: Text('${entry.value} x \$${entry.key.sellingPrice}', style: TextStyle(fontSize: 18, color: Colors.grey)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('\$${(entry.key.sellingPrice * entry.value).toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Colors.orange)),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          setModalState(() {
                                            _cartItems.remove(entry.key);
                                          });
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Products: ${_cartItems.values.fold(0, (sum, quantity) => sum + quantity)}',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    'Total: \$${_cartItems.entries.fold(0.0, (sum, entry) => sum + (entry.key.sellingPrice * entry.value)).toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setModalState(() {
                                        _cartItems.clear();
                                      });
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel', style: TextStyle(color: Colors.black),),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Implement sell functionality
                                      Navigator.pop(context);
                                    },
                                    child: Text('Sell', style: TextStyle(color: Colors.black),),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
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
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ...filteredProducts.map((product) => _buildProductCard(product)),
                  _buildAddNewCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSellsPage,
        child: Icon(Icons.shopping_cart),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _addToCart(product),
      onLongPress: () => _removeFromCart(product),
      child: Card(
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
              if (_cartItems.containsKey(product))
                Text(
                  'x${_cartItems[product]}',
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
            ],
          ),
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

class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random();
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    for (int i = 0; i < 1000; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawPoints(PointMode.points, [Offset(x, y)], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}