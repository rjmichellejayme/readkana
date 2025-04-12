import 'package:flutter/material.dart';
import '../models/chapter.dart';

class TableOfContents extends StatelessWidget {
  final List<Chapter> chapters;
  final int currentChapterIndex;
  final Function(int) onChapterSelected;

  const TableOfContents({
    Key? key,
    required this.chapters,
    required this.currentChapterIndex,
    required this.onChapterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        final isSelected = index == currentChapterIndex;
        
        return ListTile(
          title: Text(
            chapter.title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
          ),
          subtitle: Text(
            'Pages ${chapter.startPage} - ${chapter.endPage}',
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
          ),
          leading: isSelected
              ? Icon(Icons.play_arrow, color: Theme.of(context).primaryColor)
              : null,
          onTap: () => onChapterSelected(index),
        );
      },
    );
  }
}