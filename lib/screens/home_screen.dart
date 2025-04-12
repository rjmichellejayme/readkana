import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import 'book_details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ReadingService>(
        builder: (context, readingService, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentlyReading(context, readingService),
                _buildRecentBooks(context, readingService),
                _buildReadingStats(context, readingService),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement book import
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCurrentlyReading(BuildContext context, ReadingService service) {
    if (service.currentBook == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookDetailsScreen(book: service.currentBook!),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Currently Reading',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildBookCover(context, service.currentBook!),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.currentBook!.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (service.currentBook!.author != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            service.currentBook!.author!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: service.currentBook!.totalPages > 0
                              ? service.currentBook!.currentPage /
                                  service.currentBook!.totalPages
                              : 0,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${service.currentBook!.currentPage} of ${service.currentBook!.totalPages} pages read',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBooks(BuildContext context, ReadingService service) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Books',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: service.recentBooks.length,
              itemBuilder: (context, index) {
                final book = service.recentBooks[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: _buildBookCard(context, book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookCover(context, book),
          const SizedBox(height: 8),
          SizedBox(
            width: 120,
            child: Text(
              book.title,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCover(BuildContext context, Book book) {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
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
              size: 50,
              color: Colors.grey,
            )
          : null,
    );
  }

  Widget _buildReadingStats(BuildContext context, ReadingService service) {
    return Card(
      margin: const EdgeInsets.all(16.0),
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
              'Reading Speed',
              '${service.readingSpeed} pages/minute',
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
}
