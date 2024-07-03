import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'selected_stock.dart';

class MyTextField extends StatefulWidget {
  final List<int> productStock;

  const MyTextField({
    super.key,
    required this.productStock,
  });

  @override
  TableEdit createState() => TableEdit();
}

class TableEdit extends State<MyTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.productStock[0].toString());
    _controller.addListener(() {
      // Optionally, handle text changes if needed
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controller.text.length,
              );
            }
            if (!hasFocus && _controller.text.isEmpty) _controller.text = '0';
            productStock = widget.productStock;
          },
          child: Stack(
            children: [
              Positioned(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _controller,
                  onChanged: (value) {
                    widget.productStock[0] = int.tryParse(value) ?? 0;
                    productStock = widget.productStock;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'X',
                    hintStyle: TextStyle(color: Colors.orange),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                  ),
                ),
              ),
              if (widget.productStock[1] > 0)
                Positioned(
                  right: 2,
                  top: 5,
                  child: Text(
                    '+${widget.productStock[1]}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
