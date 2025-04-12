import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reading_stats.dart';
import '../services/reading_service.dart';

class ReadingStatsScreen extends StatelessWidget {
  const ReadingStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingService>(
      builder: (context, readingService, child) {
        final stats = readingService.stats;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reading Statistics'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDailyProgressCard(context, stats),
                const SizedBox(height: 16),
                _buildStreakCard(context, stats),
                const SizedBox(height: 16),
                _buildTotalStatsCard(context, stats),
                const SizedBox(height: 16),
                _buildAchievementsCard(context, stats),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyProgressCard(BuildContext context, ReadingStats stats) {
    final progress = stats.dailyProgress / stats.dailyGoal;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? Colors.green : Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${stats.dailyProgress} / ${stats.dailyGoal} pages',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, ReadingStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Streak',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  'Current Streak',
                  '${stats.currentStreak}',
                  Icons.local_fire_department,
                ),
                _buildStatColumn(
                  context,
                  'Total Days',
                  '${stats.totalReadingDays}',
                  Icons.calendar_today,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalStatsCard(BuildContext context, ReadingStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              'Total Pages Read',
              '${stats.totalPagesRead}',
              Icons.book,
            ),
            _buildStatRow(
              context,
              'Average Daily Pages',
              '${(stats.totalPagesRead / (stats.totalReadingDays > 0 ? stats.totalReadingDays : 1)).round()}',
              Icons.trending_up,
            ),
            _buildStatRow(
              context,
              'Last Read',
              stats.lastReadDate.toString().split(' ')[0],
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(BuildContext context, ReadingStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (stats.unlockedAchievements.isEmpty)
              const Center(
                child: Text('No achievements unlocked yet'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.unlockedAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = stats.unlockedAchievements[index];
                  return ListTile(
                    leading: const Icon(Icons.emoji_events),
                    title: Text(achievement),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}