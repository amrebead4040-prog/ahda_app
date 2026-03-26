class TransactionModel {
  int? id;
  String type;
  double amount;
  String date;
  String note;

  TransactionModel(
      {this.id,
      required this.type,
      required this.amount,
      required this.date,
      required this.note});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date,
      'note': note
    };
  }
}
