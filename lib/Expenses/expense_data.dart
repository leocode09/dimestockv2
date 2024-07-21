class ExpenseFormData {
  String spenderName;
  double amountSpent;
  String description;

  ExpenseFormData({
    required this.spenderName,
    required this.amountSpent,
    required this.description,
  });

  // Convert the object to a Map
  Map<String, dynamic> toMap() {
    return {
      'spenderName': spenderName,
      'amountSpent': amountSpent,
      'description': description,
    };
  }

  // Create an object from a Map
  factory ExpenseFormData.fromMap(Map<String, dynamic> map) {
    return ExpenseFormData(
      spenderName: map['spenderName'] ?? '',
      amountSpent: map['amountSpent']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
    );
  }

  // Override toString for easy printing
  @override
  String toString() {
    return 'ExpenseFormData(spenderName: $spenderName, amountSpent: $amountSpent, description: $description)';
  }
}