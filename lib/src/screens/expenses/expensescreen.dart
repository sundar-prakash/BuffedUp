
import 'package:BuffedUp/const/DataTypes/Expense.dart';
import 'package:BuffedUp/src/widget/memberform.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<ExpensesCardType> expenses = [
    ExpensesCardType(
      count: 2,
      name: 'Item 1',
      price: 20,
      purchasedon: DateTime(2023, 10, 15),
      description: 'Description for Item 1',
      imageurl: 'https://dummyimage.com/100x100/abcdef/000000',
    ),
    ExpensesCardType(
      count: 1,
      name: 'Item 2',
      price: 15,
      purchasedon: DateTime(2023, 11, 25),
      description: 'Description for Item 2',
      imageurl: 'https://dummyimage.com/100x100/abcdef/000000',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [],
          ),
          const Card(),
          ExpensesCard("title", expenses: expenses)
        ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class ExpensesCard extends StatelessWidget {
  String title;
  List<ExpensesCardType> expenses = [];
  ExpensesCard(this.title, {required this.expenses, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BigText(title),
        TextButton.icon(
          onPressed: () {},
          label: const Text("Add"),
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    // SingleChildScrollView(
    //   scrollDirection: Axis.horizontal,child: 
      ListView(
        children: expenses
            .map((e) => ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: CircleAvatar(
                    backgroundImage: e.imageurl != null
                        ? NetworkImage(e.imageurl!)
                        : null,
                  ),
                  title: Text(e.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: \$${e.price}x${e.count}'),
                      Text(yearFormat(e.purchasedon)),
                    ],
                  ),
                ))
            .toList(),
      ),
    // )
      ],
    );
  }
}
