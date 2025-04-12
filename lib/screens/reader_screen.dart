import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import '../services/sound_service.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;

  const ReaderScreen({
    super.key,
    required this.book,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final PageController _pageController = PageController();
  bool _isFullScreen = false;
  double _fontSize = 16.0;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final currentPage = _pageController.page?.round() ?? 0;
    if (currentPage != widget.book.currentPage) {
      context.read<ReadingService>().updateReadingProgress(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildReaderContent(),
          if (!_isFullScreen) _buildAppBar(),
          if (!_isFullScreen) _buildBottomBar(),
        ],
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
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Page ${index + 1} content',
            style: TextStyle(
              fontSize: _fontSize,
              color: _textColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        title: Text(
          widget.book.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_quote, color: Colors.white),
            onPressed: () {
              _showQuoteDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.note_add, color: Colors.white),
            onPressed: () {
              _showNoteDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.white),
              onPressed: () {
                _showSoundSettings();
              },
            ),
            Text(
              '${widget.book.currentPage + 1} / ${widget.book.totalPages}',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isFullScreen = !_isFullScreen;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Quote',
                hintText: 'Enter the quote text',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Save quote
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Enter your note',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Save note
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reading Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Font Size'),
              subtitle: Slider(
                value: _fontSize,
                min: 12.0,
                max: 24.0,
                divisions: 6,
                label: _fontSize.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Background Color'),
              trailing: DropdownButton<Color>(
                value: _backgroundColor,
                items: const [
                  DropdownMenuItem(
                    value: Colors.white,
                    child: Text('White'),
                  ),
                  DropdownMenuItem(
                    value: Colors.black,
                    child: Text('Black'),
                  ),
                  DropdownMenuItem(
                    value: Color(0xFFF5F5DC),
                    child: Text('Beige'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _backgroundColor = value;
                      _textColor =
                          value == Colors.black ? Colors.white : Colors.black;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSoundSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Background Sounds'),
        content: Consumer<SoundService>(
          builder: (context, soundService, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: soundService.availableSounds.length,
                  itemBuilder: (context, index) {
                    final sound = soundService.availableSounds[index];
                    final isSelected = sound == soundService.currentSound;
                    return ListTile(
                      title: Text(sound),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () {
                        if (isSelected) {
                          soundService.pauseSound();
                        } else {
                          soundService.playSound(sound);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Slider(
                  value: soundService.volume,
                  onChanged: (value) {
                    soundService.setVolume(value);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
