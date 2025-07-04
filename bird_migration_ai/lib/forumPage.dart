import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});
  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final String _discordInvite = 'https://discord.gg/RCmYGtDT';

  Future<void> _joinDiscord() async {
    final Uri url = Uri.parse(_discordInvite);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _showErrorDialog(
        title: "Error",
        content: "Unable to open Discord invite. Please try again later.",
      );
    }
  }

  void _showErrorDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1b1f3b),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2d305b),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1b1f3b),
        title: const Text(
          "FeatherTrail Forum",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Join our Discord community to discuss bird sightings, AI tools, and citizen science!",
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF629584),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _joinDiscord,
                child: const Text(
                  "Join on Discord",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
