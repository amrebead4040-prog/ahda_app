import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/transaction.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  String type = 'in';
  double amount = 0;
  String note = '';
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة عملية")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'in', child: Text("وارد")),
                  DropdownMenuItem(value: 'out', child: Text("منصرف")),
                ],
                onChanged: (v) => type = v!,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "المبلغ"),
                onSaved: (v) => amount = double.parse(v!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "البيان"),
                onSaved: (v) => note = v ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState?.save();
                    await DBHelper.instance.addTransaction(TransactionModel(
                        type: type,
                        amount: amount,
                        date: date.toIso8601String(),
                        note: note));
                    Navigator.pop(context);
                  },
                  child: const Text("حفظ"))
            ],
          ),
        ),
      ),
    );
  }
}
