// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import 'reader_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement book editing
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(context),
            _buildBookInfo(context),
            _buildReadingProgress(context),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        image: book.coverPath != null
            ? DecorationImage(
                image: FileImage(File(book.coverPath!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: book.coverPath == null
          ? const Icon(
              Icons.book,
              size: 100,
              color: Colors.grey,
            )
          : null,
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (book.author != null) ...[
            const SizedBox(height: 8),
            Text(
              'by ${book.author}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Reading Progress',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: book.totalPages > 0 ? book.currentPage / book.totalPages : 0,
          ),
          const SizedBox(height: 8),
          Text(
            '${book.currentPage} of ${book.totalPages} pages read',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildReadingProgress(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Statistics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              'Last Read',
              book.lastReadDate != null
                  ? '${book.lastReadDate!.day}/${book.lastReadDate!.month}/${book.lastReadDate!.year}'
                  : 'Never',
              Icons.calendar_today,
            ),
            _buildStatRow(
              context,
              'Reading Time',
              '${book.readingTime} minutes',
              Icons.timer,
            ),
            _buildStatRow(
              context,
              'Reading Speed',
              '${book.readingSpeed} pages/minute',
              Icons.speed,
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<ReadingService>().startReading(book);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReaderScreen(book: book),
                ),
              );
            },
            child: const Text('Continue Reading'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement bookmark management
            },
            child: const Text('Manage Bookmarks'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement notes management
            },
            child: const Text('View Notes'),
          ),
        ],
      ),
    );
  }
}
