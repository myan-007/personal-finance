import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/Transaction.dart';

void main() => {runApp(MyApp())};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: Colors.indigo,
          fontFamily: 'AndadaPro',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'QuickSand',
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
          buttonColor: Colors.white,
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'AndadaPro',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransactions = [
    // Transaction(
    //     id: 'e1', amount: 45.45, date: DateTime.now(), title: 'Choclate'),
    // Transaction(id: 'e2', amount: 34.45, date: DateTime.now(), title: 'Snacks'),
  ];
  List<Transaction> get _recentTransaction {
    return _usertransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _addTransaction(String title, double amount, DateTime choosenDate) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        amount: amount,
        date: choosenDate,
        title: title);

    setState(() {
      _usertransactions.add(tx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addTransaction),
            onTap: () {},
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("Personal Finance"),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add))
      ],
    );
    return MaterialApp(
      home: Scaffold(
        appBar: _appBar,
        body: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: (MediaQuery.of(context).size.height -
                          _appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.4,
                  child: Chart(_recentTransaction)),
              Container(
                  height: (MediaQuery.of(context).size.height -
                          _appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.6,
                  child: TransactionList(_usertransactions, _deleteTransaction)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          onPressed: () => _startAddNewTransaction(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
