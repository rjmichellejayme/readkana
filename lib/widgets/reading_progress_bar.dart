import 'package:flutter/material.dart';

class ReadingProgressBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double height;
  final Color? color;

  const ReadingProgressBar({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.height = 4.0,
    this.color,
  }) : super(key: key);

  double get progress => totalPages > 0 ? currentPage / totalPages : 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
          minHeight: height,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Page $currentPage',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}