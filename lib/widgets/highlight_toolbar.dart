import 'package:flutter/material.dart';

class HighlightToolbar extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Function() onAddNote;
  final Function() onShare;
  final Function() onCopy;

  const HighlightToolbar({
    Key? key,
    required this.onColorSelected,
    required this.onAddNote,
    required this.onShare,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildColorButton(Colors.yellow),
          _buildColorButton(Colors.green),
          _buildColorButton(Colors.blue),
          _buildColorButton(Colors.pink),
          VerticalDivider(),
          IconButton(
            icon: Icon(Icons.note_add),
            onPressed: onAddNote,
            tooltip: 'Add Note',
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: onShare,
            tooltip: 'Share',
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: onCopy,
            tooltip: 'Copy',
          ),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => onColorSelected(color),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}