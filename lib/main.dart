import 'package:dimestockv2/_date.dart';
import 'package:dimestockv2/_product.dart';
import 'package:dimestockv2/products.dart';
import 'package:dimestockv2/save_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 191, 0),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LEONIDAS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockController = TextEditingController();

  var _stock = 0;
  var _income = 0;
  var _profit = 0;

  int selectedIndex = -1;
  var _isEditing = false;

  // void deleteContact(int index) {
  //   setState(() {
  //     products.removeAt(index);
  //     saveContacts();
  //   });
  // }

  void editProduct(int index) {
    setState(() {
      selectedIndex = index;
      _nameController.text = products[index].name;
      _costPriceController.text = products[index].costPrice.toString();
      _sellingPriceController.text = products[index].sellingPrice.toString();
      _stockController.text = products[index].stock2.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    // loadProductsIntoState();
  }

  void loadProductsIntoState() async {
    final loadedProducts = await loadProducts();
    setState(() => products = loadedProducts);
  }

  void handleUnfocus(Product product) {
    saveProducts();
    updateState();
  }

  void handleTextFieldComplete(Product product) {
    saveProducts();
    updateState();
  }

  void handleTextFieldSubmit(Product product, String value) {
    product.stock2 = int.tryParse(value) ?? 0;
    saveProducts();
    updateState();
  }

  void updateState() {
    setState(() {
      _stock = products.fold<int>(
        0,
        (previousValue, product) => previousValue + product.stock2,
      );

      _income = products.fold<int>(
        0,
        (previousValue, product) =>
            previousValue +
            ((product.stock1 - product.stock2) * product.sellingPrice),
      );

      _profit = products.fold<int>(
        0,
        (previousValue, product) =>
            previousValue +
            ((product.stock1 - product.stock2) *
                (product.sellingPrice - product.costPrice)),
      );
    });
  }

  dynamic _showFormDailog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: <Widget>[
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _stock = products.fold<int>(
                      0,
                      (previousValue, product) =>
                          previousValue + product.stock2);

                  _income = products.fold<int>(
                      0,
                      (previousValue, product) =>
                          previousValue +
                          ((product.stock1 - product.stock2) *
                              product.sellingPrice));
                  _profit = products.fold<int>(
                      0,
                      (previousValue, product) =>
                          previousValue +
                          ((product.stock1 - product.stock2) *
                              (product.sellingPrice - product.costPrice)));
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
              ),
              child: const Text('Cancel'),
            ),
            _isEditing
                ? FilledButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _costPriceController.text.isNotEmpty &&
                          _sellingPriceController.text.isNotEmpty &&
                          _stockController.text.isNotEmpty) {
                        setState(() {
                          products.add(Product(
                            name: _nameController.text,
                            date: getCurrentDate(),
                            costPrice:
                                int.tryParse(_costPriceController.text) ?? 0,
                            sellingPrice:
                                int.tryParse(_sellingPriceController.text) ?? 0,
                            stock0: 0,
                            stock1: 0,
                            stock2: int.tryParse(_stockController.text) ?? 0,
                          ));
                          _nameController.clear();
                          _costPriceController.clear();
                          _sellingPriceController.clear();
                          _stockController.clear();
                          saveProducts();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('+ Add'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      // String name = nameController.text.trim();
                      // String number = numberController.text.trim();
                      // setState(() {
                      // if (name.isNotEmpty &&
                      // number.isNotEmpty &&
                      // selectedIndex != -1) {
                      // contacts[selectedIndex].name = name;
                      // contacts[selectedIndex].number = number;
                      // saveContacts();
                      // selectedIndex = -1;
                      // nameController.text = '';
                      // numberController.text = '';
                      // }
                      // });

                      _isEditing = false;
                    },
                    child: const Text('Update')),
          ],
          title: _isEditing
              ? const Text('Add New Product')
              : const Text('Edit Product'),
          content: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.9, // 90% of screen width
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Product Name',
                      prefixIcon: Icon(
                        Icons.gpp_good_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _costPriceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cost Price',
                      prefixIcon: Icon(
                        Icons.price_change_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _sellingPriceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Selling Price',
                      prefixIcon: Icon(Icons.sell_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Stock',
                      prefixIcon: Icon(
                        Icons.production_quantity_limits_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 31, 31, 31),
                letterSpacing: 2,
              ),
            ),
            FilledButton(
              onPressed: () {
                _isEditing = true;
                // setState(() {
                _showFormDailog(context);
                // });
              },
              child: const Text('+ new'),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                    color: const Color.fromARGB(255, 59, 59, 59),
                    child: Text(
                      'Stock $_stock',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                    color: const Color.fromARGB(255, 59, 59, 59),
                    child: Text(
                      'Income \$$_income',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                    color: const Color.fromARGB(255, 59, 59, 59),
                    child: Text(
                      'Profit \$$_profit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Products',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    rows: (() {
                      int index = 0;
                      return products
                          .map((product) => DataRow(
                                cells: [
                                  DataCell(
                                    InkWell(
                                      child: Text(
                                         '${++index}. ${product.name}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        // setState(() {
                                        _isEditing = true;
                                        editProduct(index) ;
                                        _showFormDailog(context);
                                        // });
                                        print('Pressed ${product.name}');
                                        
                                      },
                                    ),
                                  ),
                                ],
                              ))
                          .toList();
                    })(),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          columns: List.generate(
                            3,
                            (index) => DataColumn(
                              label: Text(
                                '6/1$index',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          rows: products
                              .map((product) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          product.stock0.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          product.stock1.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      DataCell(Focus(
                                        onFocusChange: (hasFocus) {
                                          if (!hasFocus) {
                                            handleUnfocus(product);
                                          }
                                        },
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: product.stock2.toString(),
                                          ),
                                          onChanged: (value) {
                                            product.stock2 =
                                                int.tryParse(value) ?? 0;
                                            if (value.isEmpty ||
                                                value ==
                                                    product.stock2.toString()) {
                                              return;
                                            }
                                            saveProducts();
                                            updateState();
                                          },
                                          onEditingComplete: () =>
                                              handleTextFieldComplete(product),
                                          onSubmitted: (value) =>
                                              handleTextFieldSubmit(
                                                  product, value),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            FilteringTextInputFormatter
                                                .singleLineFormatter,
                                            LengthLimitingTextInputFormatter(4)
                                          ],
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 189, 103)),
                                          decoration: const InputDecoration(
                                            hintText: 'X',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            products =
                products.map((product) => product.updateStock()).toList();
            saveProducts();
            _stock = products.fold<int>(
                0, (previousValue, product) => previousValue + product.stock2);
            _income = products.fold<int>(
                0,
                (previousValue, product) =>
                    previousValue +
                    ((product.stock1 - product.stock2) * product.sellingPrice));
            _profit = products.fold<int>(
                0,
                (previousValue, product) =>
                    previousValue +
                    ((product.stock1 - product.stock2) *
                        (product.sellingPrice - product.costPrice)));
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.keyboard_arrow_right_outlined),
      ),
    );
  }
}