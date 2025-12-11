import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer agar widget ini rebuild saat tema berubah
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Cek apakah mode saat ini adalah dark
       // final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
// atau:
//// Cek brightness yang sedang aktif di konteks saat ini
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Pengaturan Tema'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: ListTile(
                leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                title: const Text('Mode Gelap'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    // Panggil fungsi toggle dari provider
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
