import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final bool isGrid;

  const BookCard({
    Key? key,
    required this.book,
    required this.onTap,
    this.isGrid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isGrid ? _buildGridCard() : _buildListCard(),
    );
  }

  Widget _buildGridCard() {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: book.coverImage != null && book.coverImage!.isNotEmpty
                ? Image.asset(
                    book.coverImage!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.book, size: 50),
                  ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    book.author ?? 'Unknown Author', // Provide a default value
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  LinearProgressIndicator(
                    value: book.progressPercentage / 100,
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard() {
    return Card(
      elevation: 2,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 120,
            child: book.coverImage != null
                ? Image.asset(
                    book.coverImage!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.book, size: 40),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    book.author ?? 'Unknown Author', // Provide a default value
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  LinearProgressIndicator(
                    value: book.progressPercentage / 100,
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
