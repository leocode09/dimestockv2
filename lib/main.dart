import 'package:dimestockv2/products.dart';
import 'package:dimestockv2/stock_list.dart';
// import 'package:dimestockv2/stock_value.dart';

import '_date.dart';
import 'package:dimestockv2/_product.dart';
import 'package:dimestockv2/save_products.dart';
import 'package:flutter/material.dart';

import 'stock_form.dart';

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

  var index = 0;

  int selectedIndex = -1;
  bool _isEditing = false;

  List<String> dateList = [];
  // var result;

  var products = [
    Product(
        name: 'Product1',
        date: DateTime(2024, 6, 25).toString(),
        costPrice: 10,
        sellingPrice: 15,
        stock: [
          [0, 0],
          [09, 0],
          [0, 0],
          [0, 0],
          [0, 0],
          [10, 0]
        ]),
    // Product(
    //     name: 'Product2',
    //     date: DateTime(2024, 6, 28).toString(),
    //     costPrice: 20,
    //     sellingPrice: 25,
    //     stock: [
    //       [0, 0],
    //       [0, 0],
    //       [0, 0],
    //       [50, 0]
    //     ]),
    // Product(
    //     name: 'Product3',
    //     date: DateTime(2024, 6, 30).toString(),
    //     costPrice: 15,
    //     sellingPrice: 20,
    //     stock: [
    //       [35, 0]
    //     ]),
  ];

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      saveProducts();
    });
  }

  void editProduct(index, product) {
    setState(() {
      _isEditing = true;
      selectedIndex = index;

      _nameController.text = product.name;
      _costPriceController.text = product.costPrice.toString();
      _sellingPriceController.text = product.sellingPrice.toString();
      _stockController.text = product.stock.last[0].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    // loadProductsIntoState();
    dateList = getDateList(products);
    print(dateList);
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
    product.stock.last[0] = int.tryParse(value) ?? 0;
    saveProducts();
    updateState();
  }

  void _saveAndExit() {
    setState(() {
      _stock = products.fold<int>(
        0,
        (previousValue, product) => previousValue + product.stock.last[0],
      );

      _income = products.fold<int>(
        0,
        (previousValue, product) =>
            previousValue +
            ((product.stock[product.stock.length - 2][0] -
                    product.stock.last[0]) *
                product.sellingPrice),
      );

      _profit = products.fold<int>(
        0,
        (previousValue, product) =>
            previousValue +
            ((product.stock[product.stock.length - 2][0] -
                    product.stock.last[0]) *
                (product.sellingPrice - product.costPrice)),
      );
    });
  }

  void clearTextField() {
    _nameController.clear();
    _costPriceController.clear();
    _sellingPriceController.clear();
    _stockController.clear();
  }

  dynamic _showFormDailog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_isEditing)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 4, 0),
                    ),
                    onPressed: () {
                      deleteProduct(selectedIndex);
                      _isEditing = false;
                      Navigator.pop(context);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete, size: 35), // Increased icon size
                        Text('Delete'),
                      ],
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _isEditing = false;
                    clearTextField();
                    updateState();
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, size: 35), // Increased icon size
                      Text('Cancel'),
                    ],
                  ),
                ),
                if (_isEditing)
                  TextButton(
                    onPressed: () {
                      String name = _nameController.text.trim();
                      int? costPrice =
                          int.tryParse(_costPriceController.text.trim());
                      int? sellingPrice =
                          int.tryParse(_sellingPriceController.text.trim());
                      int? stock = int.tryParse(_stockController.text.trim());
                      setState(() {
                        if (_nameController.text.isNotEmpty &&
                            _costPriceController.text.isNotEmpty &&
                            _sellingPriceController.text.isNotEmpty &&
                            _stockController.text.isNotEmpty &&
                            selectedIndex != -1) {
                          products[selectedIndex].name = name;
                          products[selectedIndex].costPrice = costPrice!;
                          products[selectedIndex].sellingPrice = sellingPrice!;
                          products[selectedIndex].stock.last[0] = stock!;
                          selectedIndex = -1;
                          saveProducts();
                          clearTextField();
                        }
                      });

                      _isEditing = false;
                      Navigator.pop(context);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 35), // Increased icon size
                        Text('Update'),
                      ],
                    ),
                  ),
                if (!_isEditing)
                  TextButton(
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
                            stock: stockList(
                              dateList.length,
                              int.tryParse(_stockController.text) ?? 0,
                            ),
                          ));
                          clearTextField();
                          saveProducts();
                          dateList = getDateList(products);

                          for (var product in products) {
                            print(
                                'Name: ${product.name}, Date: ${product.date}'); // Adjust based on your properties
                          }
                          print(DateUtils.dateOnly(DateTime.now()));
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
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_outlined,
                            size: 35), // Increased icon size
                        Text('Add'),
                      ],
                    ),
                  )
              ],
            ),
          ],
          title: _isEditing
              ? const Text('Edit Product')
              : const Text('Add New Product'),
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
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  clearTextField();
                  _showFormDailog(context);
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('new'),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      return List<DataRow>.generate(products.length, (index) {
                        final product = products[index];
                        return DataRow(
                          cells: [
                            DataCell(
                              InkWell(
                                child: Text(
                                  '${index + 1}. ${product.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  editProduct(index, product);
                                  _showFormDailog(context);
                                },
                              ),
                            ),
                          ],
                        );
                      });
                    })(),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: dateList.isEmpty
                            ? const Text('nothing')
                            : DataTable(
                                columnSpacing: 20,
                                columns: List.generate(
                                  dateList.length,
                                  (index) => DataColumn(
                                    label: Text(
                                      dateList[index]
                                          .split('-')
                                          .sublist(1)
                                          .join('/'), // Format date as MM/DD
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                                rows: List.generate(
                                  products.length,
                                  (rowIndex) => DataRow(
                                    cells: List.generate(
                                      dateList.length,
                                      (cellIndex) => DataCell(
                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 500),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: ScaleTransition(
                                                scale: animation,
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: StockForm(
                                            key: ValueKey(
                                                '${rowIndex}_$cellIndex'),
                                            initialValue: products[rowIndex]
                                                .stock[cellIndex][0],
                                            onIncrement: () {
                                              // Implement increment logic
                                            },
                                            onDecrement: () {
                                              // Implement decrement logic
                                            },
                                            onChanged: (newValue) {
                                              // Implement value change logic
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // rows: products
                                //     .map((product) => DataRow(
                                //           cells: [
                                //             DataCell(
                                //               Text(
                                //                 product.stock0.toString(),
                                //                 style: const TextStyle(
                                //                   color: Colors.white,
                                //                 ),
                                //               ),
                                //             ),
                                //             DataCell(
                                //               Text(
                                //                 product.stock[product.stock.length-2][0].toString(),
                                //                 style: const TextStyle(
                                //                   color: Colors.white,
                                //                 ),
                                //               ),
                                //             ),
                                //             DataCell(Focus(
                                //               onFocusChange: (hasFocus) {
                                //                 if (!hasFocus) {
                                //                   handleUnfocus(product);
                                //                 }
                                //               },
                                //               child: TextField(
                                //                 controller: TextEditingController(
                                //                   text: product.stock.last[0].toString(),
                                //                 ),
                                //                 onChanged: (value) {
                                //                   product.stock.last[0] =
                                //                       int.tryParse(value) ?? 0;
                                //                   if (value.isEmpty ||
                                //                       value ==
                                //                           product.stock.last[0].toString()) {
                                //                     return;
                                //                   }
                                //                   saveProducts();
                                //                   updateState();
                                //                 },
                                //                 onEditingComplete: () =>
                                //                     handleTextFieldComplete(product),
                                //                 onSubmitted: (value) =>
                                //                     handleTextFieldSubmit(
                                //                         product, value),
                                //                 textAlign: TextAlign.center,
                                //                 keyboardType: TextInputType.number,
                                //                 inputFormatters: <TextInputFormatter>[
                                //                   FilteringTextInputFormatter
                                //                       .digitsOnly,
                                //                   FilteringTextInputFormatter
                                //                       .singleLineFormatter,
                                //                   LengthLimitingTextInputFormatter(4)
                                //                 ],
                                //                 style: const TextStyle(
                                //                     color: Color.fromARGB(
                                //                         255, 255, 189, 103)),
                                //                 decoration: const InputDecoration(
                                //                   hintText: 'X',
                                //                   hintStyle: TextStyle(
                                //                     color: Colors.grey,
                                //                   ),
                                //                 ),
                                //               ),
                                //             )),
                                //           ],
                                //         ))
                                //     .toList(),
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
          updateState();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.keyboard_arrow_right_outlined),
      ),
    );
  }
}
