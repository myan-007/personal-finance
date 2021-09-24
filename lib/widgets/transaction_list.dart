import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deletetx;

  TransactionList(this.transactions, this.deletetx);

  @override
  Widget build(BuildContext context) {
    return (transactions.isEmpty)
          ? Column(
              children: [
                Text(
                  "Your wallet seems full!!",
                  style: Theme.of(context).textTheme.title,
                ),
                Text(
                  'No Transaction yet!!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/wallet.png',
                    fit: BoxFit.cover,
                  ),
                  height: 150,
                )
              ],
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (tx, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text('₹${transactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    '${transactions[index].title}',
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: IconButton(
                    onPressed: () {
                      deletetx(transactions[index].id);
                    },
                    icon: Icon(Icons.delete),
                    
                  ),
                );
              },
    );
  }
}
