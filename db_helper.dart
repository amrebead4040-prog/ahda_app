import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart';

class DBHelper {
  DBHelper._();
  static final instance = DBHelper._();

  Future<Database> get db async {
    return openDatabase(join(await getDatabasesPath(), 'ahda.db'),
        onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT,
          amount REAL,
          date TEXT,
          note TEXT
        )
      ''');
    }, version: 1);
  }

  addTransaction(TransactionModel t) async {
    final d = await db;
    await d.insert('transactions', t.toMap());
  }

  getTransactions({String? type}) async {
    final d = await db;
    var result = type != null
        ? await d.query('transactions', where: 'type=?', whereArgs: [type])
        : await d.query('transactions');

    return result
        .map((e) => TransactionModel(
            id: e['id'] as int,
            type: e['type'] as String,
            amount: (e['amount'] as num).toDouble(),
            date: e['date'] as String,
            note: e['note'] as String))
        .toList();
  }

  deleteTransaction(int id) async {
    final d = await db;
    await d.delete('transactions', where: 'id=?', whereArgs: [id]);
  }
}
