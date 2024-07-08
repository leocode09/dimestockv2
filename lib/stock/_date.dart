import 'package:Leonidas/stock/_product.dart';
import 'package:intl/intl.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

List<String> getDateList(List<Product> products) {
  if (products.isEmpty) return [];

  DateTime earliestDate = DateTime.parse(products[0].date);
  for (var product in products) {
    DateTime productDate = DateTime.parse(product.date);
    if (productDate.isBefore(earliestDate)) {
      earliestDate = productDate;
    }
  }

  DateTime startDate = earliestDate;
  DateTime endDate = DateTime.now();

  int daysBetween = endDate.difference(startDate).inDays;

  return List.generate(
    daysBetween + 1,
    (index) =>
        DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: index))),
  );
}
