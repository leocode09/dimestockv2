// import 'package:intl/intl.dart';

List<String> dateList = generateDateList();

List<String> generateDateList() {
  final now = DateTime.now();
  final threeDaysAgo = now.subtract(Duration(days: 3));
  // final sevenDaysFromNow = now.add(Duration(days: 7));

  // List<String> dates = [];
  // for (var date = threeDaysAgo; date.isBefore(sevenDaysFromNow.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
  //   dates.add('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
  // }

  List<String> dates = List.generate(11, (index) {
    final date = threeDaysAgo.add(Duration(days: index));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  });

  return dates;
}
