import 'package:flutter/material.dart';
import 'package:Leonidas/stock/build_info_card.dart';
import 'package:Leonidas/stock/next_stock.dart';
import 'package:Leonidas/stock/products.dart';
import 'package:Leonidas/stock/selected_stock.dart';
import 'package:Leonidas/stock/stock_list.dart';
import 'package:Leonidas/stock/table_edit.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// import '../Expenses/bottom_bar.dart';
import '../stock/_date.dart';
import 'package:Leonidas/stock/_product.dart';
import 'package:Leonidas/stock/save_products.dart';

import '../stock/date_list.dart';

// class StockPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Stock Page'));
//   }
// }

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  // final String title;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final ScrollController _scrollController = ScrollController();

  final _nameController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _addedStockController = TextEditingController();

  int menuSelectedIndex = 0;

  var index = 0;

  var productCreateDate = getCurrentDate();

  int selectedIndex = -1;
  bool _isEditing = false;

  // ____________________________

  int stock = 0;
  int expenses = 0;
  int sells = 0;
  double income = 0;
  double profit = 0;

  String getNextDay(String dateString) {
    // Convert string to DateTime
    DateTime date = DateTime.parse(dateString);

    // Add one day
    DateTime nextDay = date.add(Duration(days: 1));

    // Convert back to string in yyyy-MM-dd format
    return '${nextDay.year}-${nextDay.month.toString().padLeft(2, '0')}-${nextDay.day.toString().padLeft(2, '0')}';
  }

  void barFunction(int index, List<Product> products) {
    sells = 0;
    income = 0;
    profit = 0;
    for (int i = 0; i < products.length; i++) {
      if (index > 0) {
        sells += (products[i].stock[index - 1][0] -
            (products[i].stock[index][0] - products[i].stock[index][1]));
        income += ((products[i].stock[index - 1][0] -
                (products[i].stock[index][0] - products[i].stock[index][1])) *
            (products[i].sellingPrice));
        profit += ((products[i].stock[index - 1][0] -
                (products[i].stock[index][0] - products[i].stock[index][1])) *
            (products[i].sellingPrice - products[i].costPrice));
      }
    }
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      saveProducts(products);
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
    loadProductsIntoState();
    for (var product in products) {
      product.stock = nextStock(product.stock, dateList.length);
    }
    dateList = getDateList(products);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  void loadProductsIntoState() async {
    final loadedProducts = await loadProducts();
    setState(() {
      products = loadedProducts;
      dateList = getDateList(products);
      if (dateList.isEmpty || products.isEmpty) {
        products.add(
          Product(
            name: "-----",
            date: DateFormat('yyyy-MM-dd')
                .format(DateTime.now().subtract(Duration(days: 7))),
            costPrice: 10.0,
            sellingPrice: 15.0,
            stock: [
              [0, 0],
            ],
          ),
        );
      }
    });

    dateList = getDateList(products);

    for (var product in products) {
      product.stock = nextStock(product.stock, dateList.length);
    }
  }

  void handleUnfocus(Product product) {
    saveProducts(products);
    // updateState();
  }

  void handleTextFieldComplete(Product product) {
    saveProducts(products);
    // updateState();
  }

  void handleTextFieldSubmit(Product product, String value) {
    product.stock.last[0] = int.tryParse(value) ?? 0;
    saveProducts(products);
    // updateState();
  }

  void clearTextField() {
    _nameController.clear();
    _costPriceController.clear();
    _sellingPriceController.clear();
    _stockController.clear();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeOut,
    );
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
                    // updateState();
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
                      double? costPrice =
                          double.tryParse(_costPriceController.text.trim());
                      double? sellingPrice =
                          double.tryParse(_sellingPriceController.text.trim());
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
                          saveProducts(products);
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
                          products.add(
                            Product(
                              name: _nameController.text,
                              date: productCreateDate,
                              costPrice:
                                  double.tryParse(_costPriceController.text) ??
                                      0,
                              sellingPrice: double.tryParse(
                                      _sellingPriceController.text) ??
                                  0,
                              stock: stockList(
                                dateList.length,
                                int.tryParse(_stockController.text) ?? 0,
                              ),
                            ),
                          );
                          clearTextField();
                          saveProducts(products);
                          dateList = getDateList(products);
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
                        Icon(Icons.add_outlined, size: 35),
                        Text('Add'),
                      ],
                    ),
                  )
              ],
            ),
          ],
          title: Row(
            children: [
              Text(_isEditing ? 'Edit Product' : 'New Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3498DB),
                  )),
              const Spacer(), // Add spacer for right alignment
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  // Get today's date
                  final DateTime now = DateTime.now();

                  // Show date picker and handle selection
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5),
                  );

                  if (selectedDate != null) {
                    // Update UI with selected date (logic for displaying the date)
                    productCreateDate = selectedDate.toString();
                    print(
                        'Selected date: $selectedDate'); // Replace with your logic
                  }
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
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
                  // keyboardType: TextInputType.number,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
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
                  // keyboardType: TextInputType.number,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  controller: _sellingPriceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Selling Price',
                    prefixIcon: Icon(Icons.sell_outlined),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 21, 21),
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LEONIDAS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 24,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  clearTextField();
                  _showFormDailog(context);
                });
              },
              icon: Icon(Icons.add, color: Color(0xFF2C3E50)),
              label: Text('New', style: TextStyle(color: Color(0xFF2C3E50))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: buildInfoCard(
                        icon: Icons.sell_outlined,
                        title: 'Sells',
                        value: '$sells',
                        gradient: [Color(0xFF1ABC9C), Color(0xFF16A085)],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildInfoCard(
                        icon: Icons.attach_money,
                        title: 'Income',
                        value: '\$$income',
                        gradient: [Color(0xFFF39C12), Color(0xFFD35400)],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildInfoCard(
                        icon: Icons.trending_up,
                        title: 'Profit',
                        value: '\$$profit',
                        gradient: [Color(0xFF3498DB), Color(0xFF2980B9)],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: 200, // Adjust as needed
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 22, 22, 22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DataTable(
                    headingRowHeight: 60,
                    // dataRowHeight: 50,
                    columnSpacing: 0,
                    columns: const [
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Text(
                            'Products',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      products.length,
                      (index) => DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (index.isEven)
                              return Color.fromARGB(255, 30, 30, 30);
                            return null;
                          },
                        ),
                        cells: [
                          DataCell(
                            InkWell(
                              child: Text(
                                '${index + 1}. ${products[index].name}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                editProduct(index, products[index]);
                                _showFormDailog(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // color: const Color.fromARGB(255, 0, 0, 0),
                      color: const Color.fromARGB(255, 21, 21, 21),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: dateList.isEmpty
                            ? Center(
                                child: Text('No data available',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0))))
                            : DataTable(
                                columnSpacing: 10,
                                headingRowHeight: 60,
                                // dataRowHeight: 50,
                                columns: List.generate(
                                  dateList.length,
                                  (index) => DataColumn(
                                    label: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          barFunction(index, products);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        decoration: BoxDecoration(
                                          // color: Color.fromARGB(255, 19, 19, 19),
                                          color:
                                              Color.fromARGB(255, 35, 35, 35),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          dateList[index]
                                              .split('-')
                                              .sublist(1)
                                              .join('/'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                rows: List.generate(
                                  products.length,
                                  (rowIndex) => DataRow(
                                    color:
                                        WidgetStateProperty.resolveWith<Color?>(
                                      (Set<WidgetState> states) {
                                        if (rowIndex.isEven)
                                          return Color.fromARGB(
                                              255, 30, 30, 30);
                                        return null;
                                      },
                                    ),
                                    cells: List.generate(
                                      dateList.length,
                                      (cellIndex) => DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          child: MyTextField(
                                            productStock: products[rowIndex]
                                                .stock[cellIndex],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80)
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 70,
            height: 50,
            child: TextField(
              controller: _addedStockController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 59, 59, 59),
                hintText: 'Added',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF3498DB),
              onPressed: () {
                setState(() {
                  if (productStock.isNotEmpty) {
                    productStock[1] =
                        int.tryParse(_addedStockController.text) ?? 0;
                  }
                  saveProducts(products);
                  _addedStockController.text = '';
                });
              },
              tooltip: 'Add',
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
