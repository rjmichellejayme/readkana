import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import '../services/theme_service.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;

  const ReaderScreen({
    super.key,
    required this.book,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  bool _isFullScreen = false;
  double _fontSize = 16.0;
  Color _backgroundColor = const Color(0xFFF3EFEA); // Default color
  Color _textColor = Colors.black;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showControls = true;

  // App theme colors
  final Color primaryColor = const Color(0xFFDA6D8F);
  final Color shelfColor = const Color(0xFFC49A6C);
  final Color backgroundColor = const Color(0xFFF3EFEA);
  final Color lightPink = const Color(0xFFF4A0BA);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    // Initialize with the book's current page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(widget.book.currentPage);
    });

    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final backgroundColor = await ThemeService.getReaderBackgroundColor();
    setState(() {
      _backgroundColor = backgroundColor;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final currentPage = _pageController.page?.round() ?? 0;
    if (currentPage != widget.book.currentPage) {
      context.read<ReadingService>().updateReadingProgress(
          currentPage); // Use the correct method with single parameter
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            _buildReaderContent(),
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildOverlayControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaderContent() {
    final List<Map<String, String>> chapters = [
      {
        'title': 'Chapter 1: The Beginning',
        'content': '''
In the heart of a bustling city, where the modern world meets ancient traditions, 
lived a young girl named Sakura. Her life was ordinary until that fateful spring 
morning when cherry blossoms danced through the air like pink snowflakes.

She had always wondered about the old bookshop at the corner of her street, 
with its weathered wooden sign and windows that seemed to glow with an otherworldly light. 
Today would be the day she finally stepped inside.

The bell above the door chimed softly as she entered, sending echoes through 
the dusty shelves that stretched toward the ceiling. The air smelled of old 
paper and forgotten stories, each book holding countless adventures within its pages.'''
      },
      {
        'title': 'Chapter 2: The Discovery',
        'content': '''
The ancient tome lay heavy in Sakura's hands, its leather cover worn smooth 
by countless readers before her. Golden characters shimmered across its spine, 
shifting and changing as if alive.

"This isn't just any book," the old shopkeeper whispered, his eyes twinkling 
with knowledge accumulated over decades. "It chooses its reader."

Sakura's fingers trembled as she opened the cover. The pages seemed to breathe, 
releasing the scent of magic and possibility. Words began to flow across the 
previously blank pages, forming themselves into a story she somehow knew was 
meant only for her.'''
      },
      {
        'title': 'Chapter 3: The Journey Begins',
        'content': '''
As night fell over the city, Sakura sat in her room, the mysterious book open 
before her. The words on the page began to glow with a soft blue light, and 
she felt a gentle tugging at the edges of her consciousness.

"To begin your journey," the book seemed to whisper, "you must first believe 
in the magic that resides within these pages."

Without hesitation, Sakura placed her hand on the glowing text. The world 
around her began to shimmer and fade, replaced by a landscape straight out 
of her wildest dreams. The adventure she had always longed for was finally 
beginning.'''
      }
    ];

    return PageView.builder(
      controller: _pageController,
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        return Container(
          color: _backgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chapter heading
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  chapters[index]['title']!,
                  style: GoogleFonts.fredoka(
                    fontSize: _fontSize + 6.0,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),

              // Chapter content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    chapters[index]['content']!,
                    style: GoogleFonts.lora(
                      fontSize: _fontSize,
                      height: 1.5,
                      color: _textColor,
                    ),
                  ),
                ),
              ),

              // Page number
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Page ${index + 1}',
                    style: GoogleFonts.fredoka(
                      fontSize: _fontSize - 2.0,
                      color: _textColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverlayControls() {
    return Stack(
      children: [
        // Top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                widget.book.title,
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: () {
                    _showBookmarkDialog();
                  },
                  tooltip: 'Add Bookmark',
                ),
                IconButton(
                  icon: const Icon(Icons.format_quote, color: Colors.white),
                  onPressed: () {
                    _showQuoteDialog();
                  },
                  tooltip: 'Add Quote',
                ),
                IconButton(
                  icon: const Icon(Icons.note_add, color: Colors.white),
                  onPressed: () {
                    _showNoteDialog();
                  },
                  tooltip: 'Add Note',
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    _showSettingsDialog();
                  },
                  tooltip: 'Settings',
                ),
              ],
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4.0,
                      activeTrackColor: primaryColor,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      thumbColor: primaryColor,
                      overlayColor: primaryColor.withOpacity(0.3),
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 14.0),
                    ),
                    child: Slider(
                      value: (_pageController.hasClients
                          ? (_pageController.page ?? 0)
                          : widget.book.currentPage.toDouble()),
                      min: 0,
                      max: (widget.book.totalPages - 1).toDouble(),
                      onChanged: (value) {
                        _pageController.jumpToPage(value.round());
                      },
                    ),
                  ),
                ),

                // Bottom bar with controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Sound button

                      // Center - Page indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${(_pageController.hasClients ? (_pageController.page?.round() ?? 0) : widget.book.currentPage) + 1} of ${widget.book.totalPages}',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Right side - Fullscreen toggle
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFullScreen = !_isFullScreen;
                            });
                          },
                          tooltip: _isFullScreen
                              ? 'Exit Fullscreen'
                              : 'Enter Fullscreen',
                        ),
                      ),
                    ],
                  ),
                ),

                // Page turn buttons - only shown when not in fullscreen
                if (!_isFullScreen)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Previous page button
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_left,
                                color: Colors.white),
                            onPressed: () {
                              if (_pageController.page! > 0) {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                          ),
                        ),

                        // Next page button
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chevron_right,
                                color: Colors.white),
                            onPressed: () {
                              if (_pageController.page! <
                                  widget.book.totalPages - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBookmarkDialog() {
    final currentPage = _pageController.page?.round() ?? 0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark, color: primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Add Bookmark',
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Add a bookmark at page ${currentPage + 1}?',
                style: GoogleFonts.fredoka(fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Bookmark Name (Optional)',
                  hintText: 'e.g., Important scene',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: shelfColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.fredoka(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Save bookmark
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: GoogleFonts.fredoka(fontSize: 16),
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

  void _showQuoteDialog() {
    final currentPage = _pageController.page?.round() ?? 0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.format_quote, color: primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Add Quote',
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Page ${currentPage + 1}',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quote',
                  hintText: 'Enter the quote text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: shelfColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.fredoka(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Save quote
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: GoogleFonts.fredoka(fontSize: 16),
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

  void _showNoteDialog() {
    final currentPage = _pageController.page?.round() ?? 0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.note_add, color: primaryColor, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Add Note',
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Page ${currentPage + 1}',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Note',
                  hintText: 'Enter your thoughts here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: shelfColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.fredoka(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Save note
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: GoogleFonts.fredoka(fontSize: 16),
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, color: primaryColor, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Reading Settings',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Font size section
                  Text(
                    'Font Size',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.text_decrease, color: Colors.grey[600]),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: primaryColor,
                            thumbColor: primaryColor,
                            overlayColor: primaryColor.withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8.0),
                          ),
                          child: Slider(
                            value: _fontSize,
                            min: 12.0,
                            max: 24.0,
                            divisions: 6,
                            onChanged: (value) {
                              setState(() {
                                _fontSize = value;
                              });
                              this.setState(() {});
                            },
                          ),
                        ),
                      ),
                      Icon(Icons.text_increase, color: Colors.grey[600]),
                    ],
                  ),
                  Center(
                    child: Text(
                      'Size: ${_fontSize.toInt()}',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Theme selection
                  Text(
                    'Theme',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Light theme
                      _buildThemeOption(
                        label: 'Light',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        isSelected: _backgroundColor == Colors.white,
                        onTap: () {
                          setState(() {
                            _backgroundColor = Colors.white;
                            _textColor = Colors.black;
                          });
                          this.setState(() {});
                        },
                      ),

                      // Sepia theme
                      _buildThemeOption(
                        label: 'Sepia',
                        backgroundColor: const Color(0xFFF5F5DC),
                        textColor: Colors.brown[800]!,
                        isSelected: _backgroundColor.value ==
                            const Color(0xFFF5F5DC).value,
                        onTap: () {
                          setState(() {
                            _backgroundColor = const Color(0xFFF5F5DC);
                            _textColor = Colors.brown[800]!;
                          });
                          this.setState(() {});
                        },
                      ),

                      // Dark theme
                      _buildThemeOption(
                        label: 'Dark',
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        isSelected: _backgroundColor == Colors.black,
                        onTap: () {
                          setState(() {
                            _backgroundColor = Colors.black;
                            _textColor = Colors.white;
                          });
                          this.setState(() {});
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Apply',
                        style: GoogleFonts.fredoka(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey[400]!,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                'Aa',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.fredoka(
              color: isSelected ? primaryColor : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showSoundSettings() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
