import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableLink extends StatelessWidget {
  final String text;
  final String url;
  final TextStyle? style;

  const ClickableLink({
    super.key,
    required this.text,
    required this.url,
    this.style,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // You might want to show a snackbar or dialog here to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchUrl,
      child: Text(
        text,
        style: style?.copyWith(
          color: Theme.of(context).colorScheme.surface,
        ) ?? 
        TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}