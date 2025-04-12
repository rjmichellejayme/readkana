import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/achievement_service.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementService>(
      builder: (context, achievementService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Achievements'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCard(context, achievementService),
                const SizedBox(height: 24),
                _buildAchievementsList(context, achievementService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(BuildContext context, AchievementService service) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              'Current Streak',
              '${service.currentStreak} days',
              Icons.local_fire_department,
            ),
            _buildStatRow(
              context,
              'Total Reading Days',
              '${service.totalReadingDays} days',
              Icons.calendar_today,
            ),
            _buildStatRow(
              context,
              'Total Pages Read',
              '${service.totalPagesRead} pages',
              Icons.book,
            ),
            _buildStatRow(
              context,
              'Daily Progress',
              '${service.dailyProgress}/${service.dailyGoal} pages',
              Icons.trending_up,
            ),
          ],
        ),
      ),
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

  Widget _buildAchievementsList(
    BuildContext context,
    AchievementService service,
  ) {
    final achievements = [
      {
        'id': 'daily_goal_completed',
        'title': 'Daily Goal Completed',
        'description': 'Complete your daily reading goal',
        'icon': Icons.emoji_events,
      },
      {
        'id': 'weekly_streak',
        'title': 'Weekly Streak',
        'description': 'Maintain a 7-day reading streak',
        'icon': Icons.star,
      },
      {
        'id': 'monthly_streak',
        'title': 'Monthly Streak',
        'description': 'Maintain a 30-day reading streak',
        'icon': Icons.stars,
      },
      {
        'id': 'thousand_pages',
        'title': 'Thousand Pages',
        'description': 'Read 1000 pages',
        'icon': Icons.bookmark,
      },
      {
        'id': 'hundred_days',
        'title': 'Hundred Days',
        'description': 'Read for 100 days',
        'icon': Icons.calendar_month,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final isUnlocked = service.unlockedAchievements
                .contains(achievement['id'] as String);

            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: Icon(
                  achievement['icon'] as IconData,
                  color:
                      isUnlocked ? Theme.of(context).primaryColor : Colors.grey,
                ),
                title: Text(
                  achievement['title'] as String,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isUnlocked ? null : Colors.grey,
                      ),
                ),
                subtitle: Text(
                  achievement['description'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isUnlocked ? null : Colors.grey,
                      ),
                ),
                trailing: Icon(
                  isUnlocked ? Icons.check_circle : Icons.lock,
                  color:
                      isUnlocked ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
