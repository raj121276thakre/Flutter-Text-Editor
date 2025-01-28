import 'package:flutter/material.dart';
import 'package:text_editor/Constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    // Check if the URL can be launched
    if (await canLaunch(url)) {
      // Launch the URL
      await launch(url);
    } else {
      // If the URL cannot be launched, throw an error
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text('About', style: TextStyle(color: theme.colorScheme.onPrimary)),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4.0,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      backgroundColor: Colors.white, // Set the background to white
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Logo or Icon
          Center(
            child: ClipOval(
              child: Image.asset(
                AppStrings.appIcon, // Path to your app's logo or icon
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // App Title
          Center(
            child: Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Version info
          Center(
            child: Text(
              AppStrings.appVersion,
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Description Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the App',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.aboutAppDescription,
                    style: TextStyle(
                        fontSize: 16, color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),

          // Developer Info Card
          // Developer Info Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.developerName,
                    style: TextStyle(
                        fontSize: 16, color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.developerDescription,
                    style: TextStyle(
                        fontSize: 16, color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Support Info Card
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support or Inquiries',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.supportText,
                    style: TextStyle(
                        fontSize: 16, color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
