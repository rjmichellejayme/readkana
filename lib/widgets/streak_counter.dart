import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/reading_service.dart';

class StreakCounter extends StatelessWidget {
  const StreakCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readingService = Provider.of<ReadingService>(context);
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reading Streak',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${readingService.currentStreak} days',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStreakStat(
                  'Longest Streak',
                  readingService.longestStreak.toString(),
                  Icons.emoji_events,
                ),
                _buildStreakStat(
                  'Total Days',
                  readingService.totalReadingDays.toString(),
                  Icons.calendar_today,
                ),
                _buildStreakStat(
                  'Books Read',
                  readingService.booksRead.toString(),
                  Icons.book,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.grey[600],
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}