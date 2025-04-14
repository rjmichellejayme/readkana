import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';

class BackgroundSoundsScreen extends StatelessWidget {
  const BackgroundSoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SoundService>(
      builder: (context, soundService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Background Sounds'),
          ),
          body: Column(
            children: [
              _buildVolumeSlider(context, soundService),
              Expanded(
                child: _buildSoundsList(context, soundService),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVolumeSlider(BuildContext context, SoundService service) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volume',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.volume_down),
                Expanded(
                  child: Slider(
                    value: service.volume,
                    onChanged: (value) => service.setVolume(value),
                  ),
                ),
                const Icon(Icons.volume_up),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundsList(BuildContext context, SoundService service) {
    return ListView.builder(
      itemCount: service.availableSounds.length,
      itemBuilder: (context, index) {
        final sound = service.availableSounds[index];
        final isSelected = sound == service.currentSound;
        final isPlaying = service.isPlaying && isSelected;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              sound.displayName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
            onTap: () {
              if (isPlaying) {
                service.pauseSound();
              } else if (isSelected) {
                service.resumeSound();
              } else {
                service.playSound(sound);
              }
            },
          ),
        );
      },
    );
  }
}
