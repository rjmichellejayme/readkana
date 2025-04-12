import 'package:flutter/material.dart';
import 'theme_switcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final bool showThemeSwitcher;
  final Function(String)? onSearch;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showSearch = false,
    this.showThemeSwitcher = true,
    this.onSearch,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: showSearch
          ? TextField(
              decoration: InputDecoration(
                hintText: 'Search books...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: onSearch,
            )
          : Text(title),
      actions: [
        if (showThemeSwitcher) ThemeSwitcher(),
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}