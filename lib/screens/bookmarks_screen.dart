import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'home_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final primaryColor = const Color(0xFFDA6D8F);
  final backgroundColor = const Color(0xFFF3EFEA);
  final shelfColor = const Color(0xFFC49A6C);
  final lightPink = const Color(0xFFF4A0BA);

  final List<Map<String, dynamic>> _mockPages = [
    {
      'page': 42,
      'bookTitle': 'The Art of Reading Japanese',
      'chapter': 'Chapter 3: Basic Kanji',
    },
    {
      'page': 78,
      'bookTitle': 'Japanese Grammar Guide',
      'chapter': 'Chapter 5: Particles',
    },
    {
      'page': 156,
      'bookTitle': 'Mastering Hiragana',
      'chapter': 'Chapter 8: Practice Exercises',
    },
  ];

  final List<Map<String, dynamic>> _mockNotes = [
    {
      'title': 'Important Grammar Rule',
      'content': 'Use は for topic marking and が for subject marking',
      'bookTitle': 'Japanese Grammar Guide',
      'date': '2024-04-14',
    },
    {
      'title': 'Vocabulary List',
      'content': '食べる (taberu) - to eat\n飲む (nomu) - to drink',
      'bookTitle': 'Basic Japanese Verbs',
      'date': '2024-04-13',
    },
    {
      'title': 'Study Reminder',
      'content': 'Practice writing these kanji 10 times each: 日、月、火',
      'bookTitle': 'The Art of Reading Japanese',
      'date': '2024-04-12',
    },
  ];

  final List<Map<String, dynamic>> _mockAnnotations = [
    {
      'text': 'て-form is used to connect actions in sequence',
      'bookTitle': 'Japanese Grammar Guide',
      'chapter': 'Verb Conjugation',
      'color': Color(0xFFF4A0BA),
    },
    {
      'text': 'Remember: カタカナ is used for foreign words',
      'bookTitle': 'Writing Systems',
      'chapter': 'Katakana Introduction',
      'color': Color(0xFFDA6D8F),
    },
    {
      'text': 'Exception to the う-verb conjugation rule',
      'bookTitle': 'Verb Mastery',
      'chapter': 'Irregular Verbs',
      'color': Color(0xFFC49A6C),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Bookmarks',
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
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: primaryColor,
              labelStyle: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Pages'),
                Tab(text: 'Notes'),
                Tab(text: 'Annotations'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPagesTab(),
                _buildNotesTab(),
                _buildAnnotationsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
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
              currentIndex: 1, // Set to 1 for Bookmarks tab
              onTap: (index) {
                if (index == 0) {
                  // Navigate to home/read screen and remove all previous routes
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                } else if (index == 2) {
                  // Navigate to Settings screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                } else if (index == 3) {
                  // Navigate to Profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                }
              },
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
      ),
    );
  }

  Widget _buildPagesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockPages.length,
      itemBuilder: (context, index) {
        final page = _mockPages[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: shelfColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "P.${page['page']}",
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              page['bookTitle'],
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
            subtitle: Text(
              page['chapter'],
              style: GoogleFonts.fredoka(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockNotes.length,
      itemBuilder: (context, index) {
        final note = _mockNotes[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note['title'],
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      note['date'],
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note['content'],
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  note['bookTitle'],
                  style: GoogleFonts.fredoka(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnotationsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockAnnotations.length,
      itemBuilder: (context, index) {
        final annotation = _mockAnnotations[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 4,
              decoration: BoxDecoration(
                color: annotation['color'],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            title: Text(
              annotation['text'],
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${annotation['bookTitle']} - ${annotation['chapter']}',
                style: GoogleFonts.fredoka(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
