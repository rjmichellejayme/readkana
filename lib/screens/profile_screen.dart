import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';
import 'home_screen.dart';
import '../utils/theme_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final primaryColor = const Color(0xFFDA6D8F);
  final backgroundColor = const Color(0xFFF3EFEA);
  final lightPink = const Color(0xFFF4A0BA);
  final shelfColor = const Color(0xFFC49A6C);

  // Mock data
  final int booksRead = 12;
  final int pagesRead = 2543;
  final int totalMinutes = 1860; // 31 hours
  final double averageWPM = 240;

  // Reading history data for chart
  final List<double> weeklyReadingData = [45, 30, 60, 75, 45, 60, 90];
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  bool _isDarkMode = false;
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    } else if (index == 3) {
      // Already on Profile screen
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    const pinkColor = Color(0xFFF4A0BA); // Define the pink color

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfo(),
                  const SizedBox(height: 24),
                  _buildReadingStats(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Reading Activity'),
                  _buildReadingActivityChart(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Reading Achievements'),
                  _buildAchievements(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Favorite Genres'),
                  _buildGenreChips(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: const Offset(0, -20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: _isDarkMode ? Colors.white : Colors.black,
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
              backgroundColor: _isDarkMode ? Colors.black : Colors.white,
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

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor,
                lightPink,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: lightPink,
            child: Text(
              'JD',
              style: GoogleFonts.fredoka(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jane Doe',
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                '@janereader',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.book, size: 16, color: primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    'Book enthusiast since April 2024',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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

  Widget _buildReadingStats() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Stats',
              style: GoogleFonts.fredoka(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    booksRead.toString(), 'Books Read', Icons.menu_book),
                _buildStatItem(
                    pagesRead.toString(), 'Pages', Icons.description),
                _buildStatItem(
                    '${(totalMinutes / 60).floor()}h ${totalMinutes % 60}m',
                    'Total Time',
                    Icons.access_time),
                _buildStatItem('$averageWPM', 'Avg. WPM', Icons.speed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: lightPink.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildReadingActivityChart() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This Week',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Reading minutes',
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: primaryColor.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${weekDays[groupIndex]}: ${rod.toY.round()} min',
                          GoogleFonts.fredoka(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              weekDays[value.toInt()],
                              style: GoogleFonts.fredoka(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 25 == 0) {
                            return Text(
                              '${value.toInt()}',
                              style: GoogleFonts.fredoka(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: weeklyReadingData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: primaryColor,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        'icon': Icons.auto_stories,
        'title': 'Bookworm',
        'description': 'Read 10 books',
        'unlocked': true,
      },
      {
        'icon': Icons.access_time_filled,
        'title': 'Dedicated Reader',
        'description': 'Read for 30+ hours',
        'unlocked': true,
      },
      {
        'icon': Icons.lightbulb,
        'title': 'Speed Reader',
        'description': 'Reach 250+ WPM',
        'unlocked': false,
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final bool unlocked = achievement['unlocked'] as bool;

          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: unlocked
                        ? lightPink.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    size: 32,
                    color: unlocked ? primaryColor : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  achievement['title'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: unlocked ? primaryColor : Colors.grey,
                  ),
                ),
                Text(
                  achievement['description'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenreChips() {
    final genres = [
      {'name': 'Fiction', 'count': 5},
      {'name': 'Non-Fiction', 'count': 3},
      {'name': 'Mystery', 'count': 2},
      {'name': 'Science', 'count': 1},
      {'name': 'Biography', 'count': 1},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: genres.map((genre) {
        return Chip(
          backgroundColor: lightPink.withOpacity(0.2),
          label: Text(
            '${genre['name']} (${genre['count']})',
            style: GoogleFonts.fredoka(
              fontSize: 14,
              color: primaryColor,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: primaryColor.withOpacity(0.3)),
          ),
        );
      }).toList(),
    );
  }
}
