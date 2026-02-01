import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_themes.dart';
import '../theme/theme_provider.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Theme'),
      ),
      body: ListView.builder(
        itemCount: appThemes.length,
        itemBuilder: (context, index) {
          final theme = appThemes[index];

          return ListTile(
            title: Text(theme.name),
            subtitle: Text(theme.description),
            trailing: const Icon(Icons.color_lens),
            onTap: () {
              themeProvider.setTheme(theme.appTheme);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
