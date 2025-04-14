import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import '../services/sound_service.dart';
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
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.book.totalPages,
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
              if (index % 5 == 0) // Just for demonstration
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Chapter ${(index ~/ 5) + 1}',
                    style: GoogleFonts.fredoka(
                      fontSize: _fontSize + 6.0,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ),

              // Page content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    'Page ${index + 1} content\n\n' +
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n' +
                        'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    style: GoogleFonts.lora(
                      fontSize: _fontSize,
                      height: 1.5,
                      color: _textColor,
                    ),
                  ),
                ),
              ),

              // Page number at bottom
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    '${index + 1}',
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.volume_up,
                              color: Colors.white, size: 22),
                          onPressed: () {
                            _showSoundSettings();
                          },
                          tooltip: 'Sound Settings',
                        ),
                      ),

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
          child: Consumer<SoundService>(
            builder: (context, soundService, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.music_note, color: primaryColor, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Background Sounds',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sound options
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: soundService.availableSounds.length,
                    itemBuilder: (context, index) {
                      final sound = soundService.availableSounds[index];
                      final isSelected = sound == soundService.currentSound;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.music_note,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                        title: Text(
                          sound.name,
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            color: isSelected ? primaryColor : Colors.grey[700],
                          ),
                        ),
                        onTap: () {
                          isSelected
                              ? soundService.stopSound()
                              : soundService.playSound(sound);
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
