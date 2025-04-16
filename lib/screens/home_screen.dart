import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import 'book_details_screen.dart';
import 'search_screen.dart';
import '../widgets/book_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import '../utils/theme_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReadingService>(context, listen: false).loadBooksFromPrefs();
    });
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final isDarkMode = await isDarkModeEnabled();
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Already on home/read screen
      setState(() {
        _selectedIndex = 0;
      });
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookmarksScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  Future<void> _handleAddBook(BuildContext context) async {
    // TODO: Replace with your preferred book adding implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Book adding feature not implemented',
          style: GoogleFonts.fredoka(),
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _openBookDetails(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book),
      ),
    );
  }

  void _showDeleteBookDialog(BuildContext context, Book book) {
    const primaryColor = Color(0xFFDA6D8F); // Define primaryColor here

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Book',
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFDA6D8F),
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${book.title}"?',
          style: GoogleFonts.fredoka(
            color: _isDarkMode
                ? const Color(0xFFF4A0BA)
                : primaryColor, // Pink in dark mode
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.fredoka(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBook(book);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.fredoka(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteBook(Book book) async {
    try {
      await Provider.of<ReadingService>(context, listen: false)
          .deleteBook(book.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Book deleted successfully',
            style: GoogleFonts.fredoka(),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error deleting book: ${e.toString()}',
            style: GoogleFonts.fredoka(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFDA6D8F);
    const shelfColor = Color(0xFFC49A6C);
    const lightPink = Color(0xFFF4A0BA);

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : const Color(0xFFF3EFEA),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.black : Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This will remove the back button
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(
            'Hello, Reader!',
            style: GoogleFonts.fredoka(
              color: _isDarkMode
                  ? const Color(0xFFF4A0BA)
                  : primaryColor, // Pink in dark mode
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
              icon: Icon(Icons.search,
                  color: _isDarkMode ? Colors.white : primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Consumer<ReadingService>(
        builder: (context, readingService, child) {
          final hasBooks = readingService.recentBooks.isNotEmpty;
          final placeholderBooks = _generatePlaceholderBooks();
          final booksToShow =
              hasBooks ? readingService.recentBooks : placeholderBooks;

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
                        child: _buildAddBookButton(context, primaryColor,
                            size: 120),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My books',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: _isDarkMode
                              ? const Color(0xFFF4A0BA)
                              : primaryColor, // Pink in dark mode
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

  Widget _buildAddBookButton(BuildContext context, Color primaryColor,
      {double size = 140}) {
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
    final bookNames = [
      'Harry Potter',
      'The Hobbit',
      'Pride and Prejudice',
      'The Great Gatsby',
      'To Kill a Mockingbird',
      'One Piece',
      'Naruto',
      'The Little Prince',
      'The Alchemist'
    ];

    return List.generate(9, (index) {
      return Book(
        id: 'placeholder_$index',
        title: bookNames[index],
        filePath: '',
        totalPages: 1,
        currentPage: 0,
        readingTime: 0,
        readingSpeed: 0,
      );
    });
  }

  Widget _buildBookShelf(
      BuildContext context, List<Book> books, Color shelfColor) {
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
                  width:
                      (MediaQuery.of(context).size.width - 32 - (2 * 12)) / 3,
                  height: 200,
                  child: BookCard(
                    book: book,
                    onTap: () => _openBookDetails(context, book),
                    onLongPress: book.id.startsWith('placeholder_')
                        ? null
                        : (book) => _showDeleteBookDialog(context, book),
                    isGrid: true,
                    indexInRow: index,
                  ),
                );
              }).toList(),
            ),
          ),
          if (books.length > 3) const SizedBox(height: 20),
          if (books.length > 3)
            _buildShelfRow(context, books.skip(3).take(3).toList(), shelfColor),
          if (books.length > 6) const SizedBox(height: 20),
          if (books.length > 6)
            _buildShelfRow(context, books.skip(6).take(3).toList(), shelfColor),
        ],
      ),
    );
  }

  Widget _buildShelfRow(
      BuildContext context, List<Book> shelfBooks, Color shelfColor) {
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
                  width:
                      (MediaQuery.of(context).size.width - 32 - (2 * 12)) / 3,
                  height: 200,
                  child: BookCard(
                    book: book,
                    onTap: () => _openBookDetails(context, book),
                    onLongPress: book.id.startsWith('placeholder_')
                        ? null
                        : (book) => _showDeleteBookDialog(context, book),
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
    const pinkColor = Color(0xFFF4A0BA); // Define the pink color

    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.black : Colors.white, // Dynamic color
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: _isDarkMode
                ? Colors.white
                : Colors.black, // Dynamic border color
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
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor:
                Colors.transparent, // Transparent to inherit container color
            elevation: 0,
            selectedItemColor: pinkColor, // Set selected icon color to pink
            unselectedItemColor: pinkColor
                .withOpacity(0.6), // Set unselected icon color to lighter pink
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
}
