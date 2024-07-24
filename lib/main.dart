import 'package:Leonidas/Expenses/Expenses1.dart';
import 'package:Leonidas/bottom_bar.dart';
import 'package:Leonidas/products/products.dart';
import 'package:Leonidas/sells/sells.dart';
import 'package:Leonidas/stock/stock.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    StockPage(),
    Products(),
    SellsPage(),
    ExpenseList(),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock management system',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed( 
      //     seedColor: Color(0xFF3498DB),
      //   ),
      //   useMaterial3: true,
      // ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: ProfessionalBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
