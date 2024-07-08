List<List<int>> stockList(int length, int stock) {
  List<List<int>> stockList = List.generate(length, (_) => [0, 0]);
  stockList.last[0] = stock;

  return stockList;
}
