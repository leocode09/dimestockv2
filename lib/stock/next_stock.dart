List<List<int>> nextStock(List<List<int>> stock, int length) {
  if (stock.length < length) {
    List<int> lastElement = stock.last;
    return [
      ...stock,
      ...List.generate(
          length - stock.length, (_) => List<int>.from(lastElement))
    ];
  }
  return stock;
}
