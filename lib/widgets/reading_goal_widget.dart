import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/reading_service.dart';

class ReadingGoalWidget extends StatelessWidget {
  const ReadingGoalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readingService = Provider.of<ReadingService>(context);
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Reading Goal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showGoalDialog(context, readingService),
                ),
              ],
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: readingService.dailyProgress / readingService.dailyGoal,
              backgroundColor: Colors.grey[200],
              minHeight: 8,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${readingService.dailyProgress} / ${readingService.dailyGoal} pages',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${((readingService.dailyProgress / readingService.dailyGoal) * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context, ReadingService readingService) {
    final controller = TextEditingController(
      text: readingService.dailyGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Daily Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Pages per day',
            suffixText: 'pages',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final goal = int.tryParse(controller.text);
              if (goal != null && goal > 0) {
                readingService.updateDailyGoal(goal);
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}