// Bookmark display

import 'package:flutter/material.dart';
import '../models/bookmark.dart';

class BookmarkList extends StatelessWidget {
  final List<Bookmark> bookmarks;
  final Function(Bookmark) onTap;
  final Function(Bookmark) onDelete;

  const BookmarkList({
    Key? key,
    required this.bookmarks,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return Center(
        child: Text(
          'No bookmarks yet',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return Dismissible(
          key: Key(bookmark.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => onDelete(bookmark),
          child: ListTile(
            leading: Icon(Icons.bookmark),
            title: Text(
              'Page ${bookmark.pageNumber}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              bookmark.note ?? 'No note',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              bookmark.date.toString().split(' ')[0],
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () => onTap(bookmark),
          ),
        );
      },
    );
  }
}
