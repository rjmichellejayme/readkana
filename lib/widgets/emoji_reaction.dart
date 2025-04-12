import 'package:flutter/material.dart';

class EmojiReaction extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final List<String> recentEmojis;

  const EmojiReaction({
    Key? key,
    required this.onEmojiSelected,
    this.recentEmojis = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentEmojis.isNotEmpty) ...[
            Text(
              'Recent',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: recentEmojis
                  .map((emoji) => _buildEmojiButton(emoji))
                  .toList(),
            ),
            Divider(),
          ],
          Text(
            'All Reactions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '😊', '❤️', '👍', '👏', '🎉', '💡', '📚', '✨',
              '🌟', '💫', '🎯', '💪', '🙌', '🤔', '😮', '😍',
            ].map((emoji) => _buildEmojiButton(emoji)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onEmojiSelected(emoji),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            emoji,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}