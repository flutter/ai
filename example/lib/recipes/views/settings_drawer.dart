import 'package:flutter/material.dart';

import '../data/settings.dart';

class SettingsDrawer extends StatelessWidget {
  SettingsDrawer({super.key, required this.onSave});
  final VoidCallback onSave;

  final controller = TextEditingController(text: Settings.foodPreferences);

  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      children: [
        const DrawerHeader(child: Text('Food Preferences')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter your food preferences...',
              border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OverflowBar(
              spacing: 8,
              children: [
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                OutlinedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Settings.setFoodPreferences(controller.text);
                    Navigator.of(context).pop();
                    onSave();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
