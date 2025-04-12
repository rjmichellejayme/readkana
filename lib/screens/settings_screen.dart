import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../services/sound_service.dart';
import '../utils/preferences_utils.dart';
import 'library_customization_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ignore: unused_field
  late bool _isDarkMode;
  // ignore: unused_field
  late double _fontSize;
  late bool _notificationsEnabled;
  late bool _autoSyncEnabled;
  late bool _soundEffectsEnabled;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _isDarkMode = await PreferencesUtils.getDarkMode();
    _fontSize = await PreferencesUtils.getFontSize();
    _notificationsEnabled = await PreferencesUtils.getNotificationsEnabled();
    _autoSyncEnabled = await PreferencesUtils.getAutoSyncEnabled();
    _soundEffectsEnabled = await PreferencesUtils.getSoundEffectsEnabled();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildThemeSection(),
          _buildReadingSection(),
          _buildLibrarySection(),
          _buildSoundSection(),
          _buildNotificationsSection(),
          _buildSyncSection(),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Enable dark theme'),
                value: themeService.isDarkMode,
                onChanged: (value) {
                  themeService.toggleTheme();
                },
              ),
              ListTile(
                title: const Text('Font Size'),
                subtitle: Slider(
                  value: themeService.fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 6,
                  label: themeService.fontSize.round().toString(),
                  onChanged: (value) {
                    themeService.updateFontSize(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadingSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Reading',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text('Default Reading Mode'),
            subtitle: const Text('Choose your preferred reading mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show reading mode options
            },
          ),
          ListTile(
            title: const Text('Reading Progress'),
            subtitle: const Text('Manage reading progress settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show reading progress settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLibrarySection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Library',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text('Library Customization'),
            subtitle: const Text('Customize library layout and display'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LibraryCustomizationScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Import/Export'),
            subtitle: const Text('Manage book imports and exports'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show import/export options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSoundSection() {
    return Consumer<SoundService>(
      builder: (context, soundService, child) {
        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sound',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SwitchListTile(
                title: const Text('Sound Effects'),
                subtitle: const Text('Enable sound effects'),
                value: _soundEffectsEnabled,
                onChanged: (value) async {
                  setState(() {
                    _soundEffectsEnabled = value;
                  });
                  await PreferencesUtils.setSoundEffectsEnabled(value);
                },
              ),
              ListTile(
                title: const Text('Background Sounds'),
                subtitle: const Text('Manage background sounds'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show background sounds settings
                },
              ),
              ListTile(
                title: const Text('Volume'),
                subtitle: Slider(
                  value: soundService.volume,
                  onChanged: (value) {
                    soundService.setVolume(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reading reminders and updates'),
            value: _notificationsEnabled,
            onChanged: (value) async {
              setState(() {
                _notificationsEnabled = value;
              });
              await PreferencesUtils.setNotificationsEnabled(value);
            },
          ),
          ListTile(
            title: const Text('Notification Settings'),
            subtitle: const Text('Customize notification preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show notification settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sync',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SwitchListTile(
            title: const Text('Auto Sync'),
            subtitle: const Text('Automatically sync reading progress'),
            value: _autoSyncEnabled,
            onChanged: (value) async {
              setState(() {
                _autoSyncEnabled = value;
              });
              await PreferencesUtils.setAutoSyncEnabled(value);
            },
          ),
          ListTile(
            title: const Text('Sync Settings'),
            subtitle: const Text('Manage sync preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show sync settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show terms of service
            },
          ),
        ],
      ),
    );
  }
}
