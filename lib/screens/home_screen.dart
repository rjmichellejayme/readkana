import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../models/book.dart';
import '../services/reading_service.dart';
import 'book_details_screen.dart';
import 'search_screen.dart';
import '../widgets/book_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleAddBook(BuildContext context) async {
    print("HomeScreen: _handleAddBook called");
    try {
      print("HomeScreen: Trying to open file picker");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'epub'],
      );

      print("HomeScreen: File picker result: $result");

      if (result != null) {
        final file = File(result.files.single.path!);
        final readingService =
            Provider.of<ReadingService>(context, listen: false);

        final newBook = Book(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: path.basenameWithoutExtension(file.path),
          filePath: file.path,
          totalPages: 100,
          currentPage: 0,
          readingTime: Duration.zero.inMilliseconds,
          readingSpeed: 0.0,
          // coverImage: 'assets/images/default_book_cover.png',
          // author: 'Unknown',
          // progressPercentage: 0.0,
        );

        await readingService.addBook(newBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("HomeScreen: User cancelled file picking");
      }
    } catch (e) {
      print("HomeScreen: Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding book: ${e.toString()}'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _handleAddBook(context),
          ),
        ),
      );
    }
  }

  void _openBookDetails(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFDA6D8F);
    const shelfColor = Color(0xFFC49A6C);
    const lightPink = Color(0xFFF4A0BA);

    return Scaffold(
      backgroundColor: const Color(0xFFF3EFEA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            'Hello, Reader!',
            style: GoogleFonts.fredoka(
              color: primaryColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: const Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: IconButton(
              icon: Icon(Icons.search, color: primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 8.0),
            child: IconButton(
              icon: Icon(Icons.turned_in_not, color: primaryColor),
              onPressed: () {
                // Handle filter
              },
            ),
          ),
        ],
      ),
      body: Consumer<ReadingService>(
        builder: (context, readingService, child) {
          final hasBooks = readingService.recentBooks.isNotEmpty;
          final placeholderBooks = _generatePlaceholderBooks();
          final booksToShow = hasBooks ? readingService.recentBooks : placeholderBooks;

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(70),
                        child: _buildAddBookButton(context, primaryColor, size: 120),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Let's add your first book!",
                        style: GoogleFonts.fredoka(
                          color: lightPink,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My books',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'Edit Shelf',
                        style: GoogleFonts.fredoka (
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBookShelf(context, booksToShow, shelfColor),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(primaryColor),
    );
  }

  Widget _buildAddBookButton(BuildContext context, Color primaryColor, {double size = 140}) {
    return GestureDetector(
      onTap: () => _handleAddBook(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
          border: Border.all(
            color: Colors.white,
            width: 4.0,
          ),
        ),
        child: Icon(
          Icons.add,
          size: size * 0.5,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Book> _generatePlaceholderBooks() {
    return List.generate(9, (index) {
      final isEven = index % 2 == 0;
      return Book(
        id: 'placeholder_$index',
        title: 'Placeholder',
        filePath: '',
        totalPages: 1,
        currentPage: 0,
        readingTime: 0,
        readingSpeed: 0,
        // coverImage: isEven ? 'assets/images/logo-beige.png' : 'assets/images/logo-pink.png',
        // author: '',
        // progressPercentage: 0,
      );
    });
  }

  Widget _buildBookShelf(BuildContext context, List<Book> books, Color shelfColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Container(
            height: 30.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: shelfColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: books.take(3).toList().asMap().entries.map((entry) {
                int index = entry.key;
                Book book = entry.value;
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 32 - (2 * 12)) / 3,
                  height: 200,
                  child: BookCard(
                    book: book,
                    onTap: () => _openBookDetails(context, book),
                    isGrid: true,
                    indexInRow: index,
                  ),
                );
              }).toList(),
            ),
          ),
          if (books.length > 3) const SizedBox(height: 20),
          if (books.length > 3) _buildShelfRow(context, books.skip(3).take(3).toList(), shelfColor),
          if (books.length > 6) const SizedBox(height: 20),
          if (books.length > 6) _buildShelfRow(context, books.skip(6).take(3).toList(), shelfColor),
        ],
      ),
    );
  }

  Widget _buildShelfRow(BuildContext context, List<Book> shelfBooks, Color shelfColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 30.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: shelfColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: shelfBooks.asMap().entries.map((entry) {
                int index = entry.key;
                Book book = entry.value;
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 32 - (2 * 12)) / 3,
                  height: 200,
                  child: BookCard(
                    book: book,
                    onTap: () => _openBookDetails(context, book),
                    isGrid: true,
                    indexInRow: index,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(Color primaryColor) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Read',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpotlightBook(Book book, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              // image: book.coverImage != null && book.coverImage!.isNotEmpty
              //     ? AssetImage(book.coverImage!) as ImageProvider
              //     : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            style: GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (book.author != null)
            Text(
              book.author!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: book.progressPercentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}