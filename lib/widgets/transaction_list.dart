import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deletetx;

  TransactionList(this.transactions, this.deletetx);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return (transactions.isEmpty)
        ? LayoutBuilder(
              builder: (ctx, contraints) {
              return Column(
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
                    height: isLandscape
                        ? contraints.maxHeight * 0.6
                        : contraints.maxHeight * 0.4,
                  )
                ],
              );
            },
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
                trailing:MediaQuery.of(context).size.width > 460 ? FlatButton.icon(
                  icon:Icon(Icons.delete),
                  label: Text("Delete"),
                  textColor: Theme.of(context).errorColor,
                  onPressed: () {
                    deletetx(transactions[index].id);
                  },
                ) : IconButton(
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
