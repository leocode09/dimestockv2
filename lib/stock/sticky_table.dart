import 'package:Leonidas/stock/_product.dart';
import 'package:Leonidas/stock/table_edit.dart';
import 'package:flutter/material.dart';

class StickyHeadersTable extends StatefulWidget {
  final List<Product> products;
  final List<String> dateList;
  final Function(int, Product) editProduct;
  final Function(int, List<Product>) barFunction;
  final Function showFormDialog;

  const StickyHeadersTable({
    Key? key,
    required this.products,
    required this.dateList,
    required this.editProduct,
    required this.barFunction,
    required this.showFormDialog,
  }) : super(key: key);

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTable> {
  late ScrollController _verticalController;
  late ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sticky first column
        SizedBox(
          width: 200, // Adjust as needed
          child: Column(
            children: [
              // Header cell for products column
              Container(
                height: 56,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Text(
                  'Products',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              // Product names
              Expanded(
                child: ListView.builder(
                  controller: _verticalController,
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 52,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          widget.editProduct(index, widget.products[index]);
                          widget.showFormDialog(context);
                        },
                        child: Text(
                          '${index + 1}. ${widget.products[index].name}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Scrollable part of the table
        Expanded(
          child: Column(
            children: [
              // Sticky header row
              SizedBox(
                height: 56,
                child: ListView.builder(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.dateList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100, // Adjust as needed
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.barFunction(index, widget.products);
                          });
                        },
                        child: Text(
                          widget.dateList[index].split('-').sublist(1).join('/'),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Table body
              Expanded(
                child: ListView.builder(
                  controller: _verticalController,
                  itemCount: widget.products.length,
                  itemBuilder: (context, rowIndex) {
                    return SizedBox(
                      height: 52,
                      child: ListView.builder(
                        controller: _horizontalController,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.dateList.length,
                        itemBuilder: (context, cellIndex) {
                          return Container(
                            width: 100, // Adjust as needed
                            alignment: Alignment.center,
                            child: MyTextField(
                              productStock: widget.products[rowIndex].stock[cellIndex],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
