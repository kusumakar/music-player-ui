import 'package:flutter/material.dart';
import 'package:music_player_ui/theme/theme.dart';
import 'package:music_player_ui/ui/feeds/feed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Music Player UI',
      theme: MusicPlayerTheme.theme,
      home: const FeedScreen(),
    );
  }
}
