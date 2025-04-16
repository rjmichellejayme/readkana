import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final Function(String) onMoodSelected;
  final String? selectedMood;

  const MoodSelector({
    Key? key,
    required this.onMoodSelected,
    this.selectedMood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'emoji': '😊', 'label': 'Happy'},
      {'emoji': '😌', 'label': 'Relaxed'},
      {'emoji': '🤔', 'label': 'Thoughtful'},
      {'emoji': '😢', 'label': 'Sad'},
      {'emoji': '😤', 'label': 'Angry'},
      {'emoji': '😴', 'label': 'Tired'},
      {'emoji': '🤩', 'label': 'Excited'},
      {'emoji': '😨', 'label': 'Scared'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling today?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: moods.map((mood) {
            final isSelected = selectedMood == mood['label'];
            return _buildMoodButton(
              mood['emoji']!,
              mood['label']!,
              isSelected,
              () => onMoodSelected(mood['label']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodButton(
    String emoji,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}