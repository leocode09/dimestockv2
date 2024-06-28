import 'package:dimestockv2/_product.dart';
import 'package:intl/intl.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  return now.toString();
}

List<String> getDateList(List<Product> products) {
  if (products.isEmpty) {
    return ['No products found'];
  }

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
