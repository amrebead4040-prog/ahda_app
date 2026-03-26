import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/transaction.dart';

class ListScreen extends StatefulWidget {
  final String type;
  const ListScreen({super.key, required this.type});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.type == 'in' ? "الوارد" : "المنصرف")),
      body: FutureBuilder<List<TransactionModel>>(
        future: DBHelper.instance.getTransactions(type: widget.type),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          var list = snap.data!;
          if (list.isEmpty) {
            return const Center(child: Text("لا يوجد بيانات"));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (c, i) {
              var t = list[i];
              return ListTile(
                title: Text("${t.amount} جنيه"),
                subtitle: Text(t.note),
                trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await DBHelper.instance.deleteTransaction(t.id!);
                      setState(() {});
                    }),
              );
            },
          );
        },
      ),
    );
  }
}
