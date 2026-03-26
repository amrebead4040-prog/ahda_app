import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/transaction.dart';
import 'add_screen.dart';
import 'list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalIn = 0;
  double totalOut = 0;

  @override
  void initState() {
    super.initState();
    fetchTotals();
  }

  fetchTotals() async {
    List<TransactionModel> list =
        await DBHelper.instance.getTransactions();
    double inSum = 0, outSum = 0;
    for (var t in list) {
      if (t.type == 'in') inSum += t.amount;
      if (t.type == 'out') outSum += t.amount;
    }
    setState(() {
      totalIn = inSum;
      totalOut = outSum;
    });
  }

  @override
  Widget build(BuildContext context) {
    double balance = totalIn - totalOut;

    return Scaffold(
      appBar: AppBar(title: const Text("العهدة")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: InfoCard(
                        title: "الوارد",
                        value: "${totalIn.toStringAsFixed(2)} جنيه",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ListScreen(type: 'in'))))),
                const SizedBox(width: 10),
                Expanded(
                    child: InfoCard(
                        title: "المنصرف",
                        value: "${totalOut.toStringAsFixed(2)} جنيه",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ListScreen(type: 'out'))))),
              ],
            ),
            const SizedBox(height: 10),
            InfoCard(
                title: "الرصيد",
                value: "${balance.toStringAsFixed(2)} جنيه",
                onTap: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddScreen()));
          fetchTotals();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  const InfoCard(
      {super.key, required this.title, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.teal[100],
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
