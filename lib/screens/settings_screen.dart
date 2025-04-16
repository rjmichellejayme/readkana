import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'bookmarks_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final primaryColor = const Color(0xFFDA6D8F);
  final backgroundColor = const Color(0xFFF3EFEA);
  final lightPink = const Color(0xFFF4A0BA);
  final shelfColor = const Color(0xFFC49A6C);

  // Example settings
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _textSize = 16.0;
  String _selectedTheme = 'Default';
  int _selectedIndex = 2;

  // User information
  String _userName = 'Jane Doe';
  String _userEmail = 'jane.doe@example.com';
  String _userInitials = 'JD';

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _saveTheme(String themeName, Color themeColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', themeName);
    await prefs.setInt('themeColor', themeColor.value);
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _darkModeEnabled = value;
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookmarksScreen()),
      );
    } else if (index == 2) {
      // Already on Settings screen
      return;
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const pinkColor = Color(0xFFF4A0BA); // Define the pink color

    return Scaffold(
      backgroundColor: _darkModeEnabled ? Colors.black : backgroundColor,
      appBar: AppBar(
        backgroundColor: _darkModeEnabled ? Colors.black : Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: _darkModeEnabled ? Colors.white : primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.fredoka(
            color: _darkModeEnabled ? Colors.white : primaryColor,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Account'),
              _buildAccountCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Reading Preferences'),
              _buildSettingsCard([
                _buildTextSizeSetting(),
                const Divider(height: 1),
                _buildThemeSelector(),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle('App Settings'),
              _buildSettingsCard([
                _buildSwitchSetting(
                  'Notifications',
                  'Receive reading reminders',
                  _notificationsEnabled,
                  (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                const Divider(height: 1),
                _buildSwitchSetting(
                  'Dark Mode',
                  'Use dark theme for app theme',
                  _darkModeEnabled,
                  (value) async {
                    _toggleDarkMode(value);
                  },
                ),
              ]),
              const SizedBox(height: 24),
              _buildSectionTitle('About'),
              _buildSettingsCard([
                _buildActionItem(
                  'Privacy Policy',
                  Icons.privacy_tip_outlined,
                  () {
                    // Handle privacy policy tap
                  },
                ),
                const Divider(height: 1),
                _buildActionItem(
                  'Terms of Service',
                  Icons.description_outlined,
                  () {
                    // Handle terms tap
                  },
                ),
                const Divider(height: 1),
                _buildActionItem(
                  'App Version',
                  Icons.info_outline,
                  () {},
                  subtitle: '1.0.0',
                ),
              ]),
              const SizedBox(height: 32),
              _buildSignOutButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: const Offset(0, -20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: _darkModeEnabled ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: _darkModeEnabled ? Colors.white : Colors.black,
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
              currentIndex: _selectedIndex, // Set to 2 for Settings tab
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: _darkModeEnabled ? Colors.black : Colors.white,
              elevation: 0,
              selectedItemColor: pinkColor, // Set selected icon color to pink
              unselectedItemColor: pinkColor.withOpacity(
                  0.6), // Set unselected icon color to lighter pink
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.fredoka(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: lightPink,
              child: Text(
                _userInitials,
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _userEmail,
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: primaryColor),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );

                // Refresh the settings screen if changes were made
                if (result == true) {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    // Update the displayed user information
                    final userName = prefs.getString('userName') ?? 'Jane Doe';
                    final userEmail =
                        prefs.getString('userEmail') ?? 'jane.doe@example.com';
                    final userInitials =
                        prefs.getString('userInitials') ?? 'JD';

                    // Update the UI with new values
                    _userName = userName;
                    _userEmail = userEmail;
                    _userInitials = userInitials;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTextSizeSetting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Text Size',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_textSize.toInt()}',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Slider(
            value: _textSize,
            min: 12.0,
            max: 24.0,
            divisions: 6,
            activeColor: primaryColor,
            inactiveColor: lightPink.withOpacity(0.3),
            onChanged: (value) {
              setState(() {
                _textSize = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'A',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'A',
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: GoogleFonts.fredoka(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildThemeOption('Default', const Color(0xFFF3EFEA)),
                _buildThemeOption('Sepia', const Color(0xFFF9F1E6)),
                _buildThemeOption('Dark', const Color(0xFF303030)),
                _buildThemeOption('Sky', const Color(0xFFE6F4F9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String name, Color color) {
    final isSelected = _selectedTheme == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = name;
        });
        _saveTheme(name, color); // Save theme when selected
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? primaryColor : Colors.grey.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: isSelected ? Icon(Icons.check, color: primaryColor) : null,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: GoogleFonts.fredoka(
                fontSize: 12,
                color: isSelected ? primaryColor : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(String title, IconData icon, VoidCallback onTap,
      {String? subtitle}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: primaryColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: () {
          // Navigate to login screen and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false, // This removes all previous routes
          );
        },
        child: Text(
          'Sign Out',
          style: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
