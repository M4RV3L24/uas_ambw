import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'app_theme.dart';
import 'providers/notes_provider.dart';
import 'screens/notes_screen.dart';
import 'screens/add_note_screen.dart';
import 'settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Aplikasi Catatan',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (context) => const NotesScreen());
                case '/add-note':
                  final args = settings.arguments as Map<String, dynamic>?;
                  return MaterialPageRoute(
                    builder: (context) => AddNoteScreen(
                      note: args?['note'],
                      noteIndex: args?['index'],
                    ),
                  );
                case '/settings':
                  return MaterialPageRoute(builder: (context) => const SettingsPage());
                default:
                  return MaterialPageRoute(builder: (context) => const NotesScreen());
              }
            },
          );
        },
      ),
    );
  }
}

