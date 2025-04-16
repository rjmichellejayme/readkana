import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/reading_service.dart';

class FontSizeSelector extends StatelessWidget {
  const FontSizeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readingService = Provider.of<ReadingService>(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Font Size',
          style: TextStyle(fontSize: 16),
        ),
        Slider(
          value: readingService.fontSize,
          min: 12,
          max: 24,
          divisions: 6,
          label: readingService.fontSize.round().toString(),
          onChanged: (value) {
            readingService.updateFontSize(value);
          },
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('A', style: TextStyle(fontSize: 12)),
            Text('A', style: TextStyle(fontSize: 24)),
          ],
        ),
      ],
    );
  }
}