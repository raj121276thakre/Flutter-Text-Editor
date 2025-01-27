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

    return MaterialApp(
      title: 'NotePad',
      theme: ThemeData(
        primaryColor: const Color(0xFFC80F4F),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            0xFFC80F4F,
            {
              50: const Color(0xFFFFE6EB),
              100: const Color(0xFFFFB3C2),
              200: const Color(0xFFFF8098),
              300: const Color(0xFFFF4D6E),
              400: const Color(0xFFFF264E),
              500: const Color(0xFFC80F4F),
              600: const Color(0xFF9F0C3E),
              700: const Color(0xFF76082E),
              800: const Color(0xFF4E051E),
              900: const Color(0xFF26030F),
            },
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC80F4F),
          foregroundColor: Colors.white,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFFC80F4F),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
