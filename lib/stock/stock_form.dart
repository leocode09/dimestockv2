import 'package:flutter/material.dart';

class StockForm extends StatefulWidget {
  final int initialValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onChanged;

  const StockForm({
    super.key,
    required this.initialValue,
    required this.onIncrement,
    required this.onDecrement,
    required this.onChanged,
  });

  @override
  StockFormState createState() => StockFormState();
}

class StockFormState extends State<StockForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove, color: Colors.white),
          onPressed: () {
            int currentValue = int.parse(_controller.text);
            if (currentValue > 0) {
              _controller.text = (currentValue - 1).toString();
              widget.onDecrement();
              widget.onChanged(currentValue - 1);
            }
          },
        ),
        SizedBox(
          width: 50,
          child: TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            onChanged: (value) {
              widget.onChanged(int.tryParse(value) ?? 0);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            int currentValue = int.parse(_controller.text);
            _controller.text = (currentValue + 1).toString();
            widget.onIncrement();
            widget.onChanged(currentValue + 1);
          },
        ),
      ],
    );
  }
}