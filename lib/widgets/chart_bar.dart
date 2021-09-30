import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double totalSpendingPrOfTotal;

  ChartBar(this.label, this.spendingAmount, this.totalSpendingPrOfTotal);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, contraints) {
        return Column(
          
          children: [
            Container(
              height: contraints.maxHeight * 0.125,
              child: FittedBox(
                  child: Text('₹${spendingAmount.toStringAsFixed(0)}')),
            ),
            SizedBox(
              height: contraints.maxHeight * 0.05,
            ),
            Container(
              height: contraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.indigo.shade50,
                        width: 1.0,
                      ),
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: totalSpendingPrOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: contraints.maxHeight * 0.05,
            ),
            Container(
                height: contraints.maxHeight * 0.125,
                child: Text(
                  '$label',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        );
      },
    );
  }
}
