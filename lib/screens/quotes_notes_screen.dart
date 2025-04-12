import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../models/quote.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class QuotesNotesScreen extends StatefulWidget {
  final Book? book;

  const QuotesNotesScreen({
    super.key,
    this.book,
  });

  @override
  State<QuotesNotesScreen> createState() => _QuotesNotesScreenState();
}

class _QuotesNotesScreenState extends State<QuotesNotesScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Quote> _quotes = [];
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuotesAndNotes();
  }

  Future<void> _loadQuotesAndNotes() async {
    setState(() => _isLoading = true);
    try {
      if (widget.book != null) {
        _quotes = await _databaseService.getQuotes(widget.book!.id);
        _notes = await _databaseService.getNotes(widget.book!.id);
      } else {
        _quotes = await _databaseService.getAllQuotes();
        _notes = await _databaseService.getAllNotes();
      }
    } catch (e) {
      print('Error loading quotes and notes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quotes and notes')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.book?.title ?? 'Quotes & Notes'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Quotes'),
              Tab(text: 'Notes'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildQuotesList(),
                  _buildNotesList(),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildQuotesList() {
    if (_quotes.isEmpty) {
      return const Center(
        child: Text('No quotes saved yet'),
      );
    }

    return ListView.builder(
      itemCount: _quotes.length,
      itemBuilder: (context, index) {
        final quote = _quotes[index];
        return Dismissible(
          key: Key(quote.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _databaseService.deleteQuote(quote.id);
            setState(() {
              _quotes.removeAt(index);
            });
          },
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                quote.text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (quote.bookTitle != null)
                    Text(
                      'From: ${quote.bookTitle}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  Text(
                    'Page ${quote.page}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditQuoteDialog(context, quote);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesList() {
    if (_notes.isEmpty) {
      return const Center(
        child: Text('No notes saved yet'),
      );
    }

    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return Dismissible(
          key: Key(note.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _databaseService.deleteNote(note.id);
            setState(() {
              _notes.removeAt(index);
            });
          },
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                note.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditNoteDialog(context, note);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.format_quote),
              title: const Text('Quote'),
              onTap: () {
                Navigator.pop(context);
                _showAddQuoteDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Note'),
              onTap: () {
                Navigator.pop(context);
                _showAddNoteDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddQuoteDialog(BuildContext context) {
    final textController = TextEditingController();
    final pageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Quote',
                hintText: 'Enter the quote text',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pageController,
              decoration: const InputDecoration(
                labelText: 'Page',
                hintText: 'Enter the page number',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (textController.text.isNotEmpty &&
                  pageController.text.isNotEmpty) {
                final quote = Quote(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  text: textController.text,
                  page: int.parse(pageController.text),
                  bookId: widget.book?.id,
                  bookTitle: widget.book?.title,
                );
                await _databaseService.insertQuote(quote);
                setState(() {
                  _quotes.add(quote);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter note title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter note content',
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
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                final note = Note(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  content: contentController.text,
                  bookId: widget.book?.id,
                  bookTitle: widget.book?.title,
                );
                await _databaseService.insertNote(note);
                setState(() {
                  _notes.add(note);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditQuoteDialog(BuildContext context, Quote quote) {
    final textController = TextEditingController(text: quote.text);
    final pageController = TextEditingController(text: quote.page.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Quote',
                hintText: 'Enter the quote text',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pageController,
              decoration: const InputDecoration(
                labelText: 'Page',
                hintText: 'Enter the page number',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (textController.text.isNotEmpty &&
                  pageController.text.isNotEmpty) {
                final updatedQuote = quote.copyWith(
                  text: textController.text,
                  page: int.parse(pageController.text),
                );
                await _databaseService.updateQuote(updatedQuote);
                setState(() {
                  final index = _quotes.indexWhere((q) => q.id == quote.id);
                  if (index != -1) {
                    _quotes[index] = updatedQuote;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter note title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter note content',
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
            onPressed: () async {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                final updatedNote = note.copyWith(
                  title: titleController.text,
                  content: contentController.text,
                );
                await _databaseService.updateNote(updatedNote);
                setState(() {
                  final index = _notes.indexWhere((n) => n.id == note.id);
                  if (index != -1) {
                    _notes[index] = updatedNote;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
