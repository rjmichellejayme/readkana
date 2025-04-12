import 'package:flutter/material.dart';
import '../utils/preferences_utils.dart';

class LibraryCustomizationScreen extends StatefulWidget {
  const LibraryCustomizationScreen({super.key});

  @override
  State<LibraryCustomizationScreen> createState() =>
      _LibraryCustomizationScreenState();
}

class _LibraryCustomizationScreenState
    extends State<LibraryCustomizationScreen> {
  late String _layoutStyle;
  late bool _showAuthor;
  late bool _showProgress;
  late bool _showLastRead;
  late int _sortBy;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _layoutStyle = await PreferencesUtils.getLibraryLayoutStyle();
    _showAuthor = await PreferencesUtils.getShowAuthor();
    _showProgress = await PreferencesUtils.getShowProgress();
    _showLastRead = await PreferencesUtils.getShowLastRead();
    _sortBy = await PreferencesUtils.getLibrarySortBy();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Customization'),
      ),
      body: ListView(
        children: [
          _buildLayoutStyleSection(),
          _buildDisplayOptionsSection(),
          _buildSortOptionsSection(),
        ],
      ),
    );
  }

  Widget _buildLayoutStyleSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layout Style',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'grid',
                  label: Text('Grid'),
                  icon: Icon(Icons.grid_view),
                ),
                ButtonSegment<String>(
                  value: 'list',
                  label: Text('List'),
                  icon: Icon(Icons.list),
                ),
              ],
              selected: {_layoutStyle},
              onSelectionChanged: (value) {
                setState(() {
                  _layoutStyle = value.first;
                  PreferencesUtils.setLibraryLayoutStyle(_layoutStyle);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayOptionsSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Display Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Show Author'),
              subtitle: const Text('Display author name under book title'),
              value: _showAuthor,
              onChanged: (value) {
                setState(() {
                  _showAuthor = value;
                  PreferencesUtils.setShowAuthor(value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Show Progress'),
              subtitle: const Text('Display reading progress bar'),
              value: _showProgress,
              onChanged: (value) {
                setState(() {
                  _showProgress = value;
                  PreferencesUtils.setShowProgress(value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Show Last Read'),
              subtitle: const Text('Display last read date'),
              value: _showLastRead,
              onChanged: (value) {
                setState(() {
                  _showLastRead = value;
                  PreferencesUtils.setShowLastRead(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOptionsSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            RadioListTile<int>(
              title: const Text('Title'),
              subtitle: const Text('Sort alphabetically by title'),
              value: 0,
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  PreferencesUtils.setLibrarySortBy(value);
                });
              },
            ),
            RadioListTile<int>(
              title: const Text('Author'),
              subtitle: const Text('Sort alphabetically by author'),
              value: 1,
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  PreferencesUtils.setLibrarySortBy(value);
                });
              },
            ),
            RadioListTile<int>(
              title: const Text('Last Read'),
              subtitle: const Text('Sort by most recently read'),
              value: 2,
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  PreferencesUtils.setLibrarySortBy(value);
                });
              },
            ),
            RadioListTile<int>(
              title: const Text('Progress'),
              subtitle: const Text('Sort by reading progress'),
              value: 3,
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  PreferencesUtils.setLibrarySortBy(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
