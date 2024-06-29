import 'package:flutter/material.dart';

import '_product.dart';

String getStockValue(Product product, String compareDate) {
  final productDate = DateUtils.dateOnly(DateTime.parse(product.date));
  final comparisonDate = DateTime.parse(compareDate);
  final stockValue = product.stock2.toString();
  return productDate.compareTo(comparisonDate) <= 0 ? stockValue : '0';
}
