import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import '../models/Transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart(this.recentTransaction);

  List<Map<String, dynamic>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekday.day &&
            recentTransaction[i].date.month == weekday.month &&
            recentTransaction[i].date.year == weekday.year) {
          totalSum += recentTransaction[i].amount;
        }
      }
      

      return {
        'day': DateFormat.E().format(weekday).substring(0,1),
         'amount': totalSum
         };
    }).reversed.toList();
  }
  double get totalSpending{
    return groupTransactionValues.fold(0.0, (sum, item){
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupTransactionValues);
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groupTransactionValues.map((data) {
          return Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ChartBar(data['day'] ,
                        data['amount'] ,
                        (totalSpending==0)? 0.0: (data['amount'] as double)/totalSpending),
              ),
          );
        }).toList(),
      ),
    );
  }
}
