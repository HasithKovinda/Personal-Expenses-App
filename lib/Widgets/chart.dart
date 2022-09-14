import 'dart:ffi';

import 'package:flutter/material.dart';
import '../Model/transaction.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var total = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          total += recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': total
      };
    });
  }

  double get totalSpend {
    return groupTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupTransactionValues.map((e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    e['day'] as String,
                    e['amount'] as double,
                    totalSpend == 0.0
                        ? 0.0
                        : (e['amount'] as double) / totalSpend),
              );
            }).toList()),
      ),
    );
  }
}
