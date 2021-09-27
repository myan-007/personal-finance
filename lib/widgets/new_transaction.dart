import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final textinput = TextEditingController();
  final amountinput = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (amountinput.text.isEmpty) {
      return;
    }
    final enteredtitle = textinput.text;
    final enteredamount = double.parse(amountinput.text);

    if (enteredtitle.isEmpty || enteredamount <= 0 || _selectedDate == null)
      return;
    widget.addTx(
      enteredtitle,
      enteredamount,
      _selectedDate,
    );

    Navigator.of(context).pop();
    print(textinput.text);
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom:10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: textinput,
              onSubmitted: (_) => {_submitData()},
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Amount",
              ),
              controller: amountinput,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) =>
                  {_submitData()}, // _ used to get value but not used
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                      child: Text(_selectedDate == null
                          ? "Date not choosen!!"
                          : 'Picked Date :${DateFormat.yMd().format(_selectedDate)}  ')),
                  FlatButton(
                    onPressed: presentDatePicker,
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            RaisedButton(
              onPressed: _submitData,
              color: Theme.of(context).primaryColor,
              child: Text(
                'Submit',
                style: TextStyle(color: Theme.of(context).buttonColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
