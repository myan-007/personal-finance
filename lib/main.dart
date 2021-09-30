import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/Transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(MyApp());
}

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

  bool _showChart = false;

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
        isScrollControlled: true,
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
    final mediaquery = MediaQuery.of(context);
    final isLandscape = mediaquery.orientation == Orientation.landscape;
    final PreferredSizeWidget _appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text("Personal Finance"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
                if (isLandscape) Text("Chart"),
                if (isLandscape)
                  Switch.adaptive(
                      activeColor: Colors.indigo.shade100,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
              ],
            ))
        : AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Personal Finance"),
            actions: [
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(Icons.add)),
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Chart"),
                    Switch.adaptive(
                        activeColor: Colors.indigo.shade200,
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            _showChart = val;
                          });
                        }),
                  ],
                ),
            ],
          );

    final txListWidget = Container(
        height: (mediaquery.size.height -
                _appBar.preferredSize.height -
                mediaquery.padding.top) *
            0.7,
        child: TransactionList(_usertransactions, _deleteTransaction));
    final appbody = SafeArea(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          if (!isLandscape)
            Container(
                height: (mediaquery.size.height -
                        _appBar.preferredSize.height -
                        mediaquery.padding.top) *
                    0.3,
                child: Chart(_recentTransaction)),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            (_showChart)
                ? Container(
                    height: (mediaquery.size.height -
                            _appBar.preferredSize.height -
                            mediaquery.padding.top) *
                        0.7,
                    child: Chart(_recentTransaction))
                : txListWidget,
        ],
      ),
    ));
    return MaterialApp(
      home: Platform.isIOS
          ? CupertinoPageScaffold(
              child: appbody,
              navigationBar: _appBar,
            )
          : Scaffold(
              appBar: _appBar,
              body: appbody,
              floatingActionButton: Platform.isIOS
                  ? SizedBox()
                  : FloatingActionButton(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      onPressed: () => _startAddNewTransaction(context),
                      child: Icon(Icons.add),
                    ),
            ),
    );
  }
}
