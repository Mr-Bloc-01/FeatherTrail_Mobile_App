import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2d305b), // Main dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1b1f3b), // Darker blue for the AppBar
        title: const Text(
          'Bird Migration Project',
          style: TextStyle(
            color: Colors.white, // White text for contrast
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bird Migration Project',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE2F1E7), // Off-white for headings
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This app is designed to help users explore the fascinating world of bird migration. '
                  'By leveraging advanced AI models and user-contributed data, we aim to provide meaningful insights into '
                  'how birds navigate across different regions and how environmental factors influence their journeys.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70, // Subtle white shade for body text
              ),
            ),
            SizedBox(height: 20),
            SectionTitle(title: 'What You Can Do:'),
            BulletPoint(
              text: 'Predict bird migration patterns based on changes in temperature and wind speed.',
            ),
            BulletPoint(
              text: 'Identify bird species by uploading an image to our AI-powered classifier.',
            ),
            BulletPoint(
              text: 'Contribute your own bird sighting data to improve our predictions.',
            ),
            SizedBox(height: 20),
            SectionTitle(title: 'Our Mission:'),
            Text(
              'Understanding bird migration is critical for conservation and ecological studies. With this app, we bring together '
                  'technology and user participation to deepen our understanding of migratory patterns and help protect these species.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Join us in exploring the mysteries of bird migration and contributing to global conservation efforts.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Color(0xFF9ec1b8), // Soft sage green for emphasis
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFE2F1E7), // Off-white for bullet points
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF387478), // Accent dark green for subheadings
        ),
      ),
    );
  }
}
