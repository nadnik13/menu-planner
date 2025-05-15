

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayList extends StatelessWidget{
  final int range = 30;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayIndex = range;

    return SizedBox(
      height: 120,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
        itemCount: 2*range +1,
        itemBuilder: (context, index){
            final offset = index - todayIndex;
            final date = now.add(Duration(days: offset));
            return DayCard(date);
        },
      ),
    );
    throw UnimplementedError();
  }
}

Widget DayCard(DateTime date){
  return Card(
    margin: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.teal[50],
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Среда, 15 мая',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.breakfast_dining, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(child: Text('Овсянка с бананом')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.lunch_dining, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('Куриная грудка с картошкой и салатом')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.dinner_dining, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(child: Text('Творожная запеканка')),
            ],
          ),
        ],
      ),
    ),
  );
}