import 'package:dimestockv2/_product.dart';
import 'package:intl/intl.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  return now.toString();
}

// DateTime? _startDate;
// DateTime? _endDate;
// int _daysBetween = 0;
// List<String> _dateList = [];

// void calculateDays() {
//   if (_startDate != null && _endDate != null) {
//     // Ensure start date is always before or equal to end date
//     DateTime startDate =
//         _startDate!.isBefore(_endDate!) ? _startDate! : _endDate!;
//     DateTime endDate = _endDate!.isAfter(_startDate!) ? _endDate! : _startDate!;

//     _daysBetween = endDate.difference(startDate).inDays;
//     _dateList = List.generate(
//       _daysBetween + 1,
//       (index) => _formatDate(startDate.add(Duration(days: index))),
//     );
//   }
// }

// String _formatDate(DateTime date) {
//   print('startDate: $_startDate, endDate: $_endDate -- $date');
//   return DateFormat('yyyy-MM-dd').format(date);
// }

// Map<String, String> getEarliestAndCurrentDate(List<Product> products) {
//   if (products.isEmpty) {
//     return {
//       'earliestDate': 'No products found',
//       'currentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//     };
//   }

//   DateTime earliestDate = DateTime.parse(products[0].date);

//   for (var product in products) {
//     DateTime productDate = DateTime.parse(product.date);
//     if (productDate.isBefore(earliestDate)) {
//       earliestDate = productDate;
//     }
//   }

//   return {
//     'earliestDate': DateFormat('yyyy-MM-dd').format(earliestDate),
//     'currentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
//   };
// }

// Optional: Create getters to access the calculated values if needed
// var startDate = _startDate;
// var endDate = _endDate;
// int get daysBetween => _daysBetween;
// List<String> get dateList => _dateList;

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
