import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/Screens/splash_screen.dart';
import 'Providers/note_provider.dart';
import 'Providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Load theme on startup
    themeProvider.init();

    return MaterialApp(
      title: 'NotePad',
      theme: themeProvider.currentTheme, // Use the current theme from ThemeProvider
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
    );
  }
}
