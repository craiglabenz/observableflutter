import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Theme')),
          Watch((context) {
            final mode = settingsService.themeMode.value;
            return SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {mode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                settingsService.setThemeMode(newSelection.first);
              },
            );
          }),
          const Divider(),
          const ListTile(title: Text('Text Scale')),
          Watch((context) {
            final scale = settingsService.textScale.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Current Scale: ${scale.toStringAsFixed(1)}x',
                    style: TextStyle(fontSize: 16 * scale), // Demo text scaling
                  ),
                ),
                Slider(
                  value: scale,
                  min: 0.8,
                  max: 2.0,
                  divisions: 12,
                  label: scale.toStringAsFixed(1),
                  onChanged: (value) => settingsService.setTextScale(value),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
