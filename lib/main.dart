import 'package:flutter/material.dart';
import 'screens/folders_screen.dart';

void main() {
  runApp(CardOrganizerApp());
}

class CardOrganizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FoldersScreen(),
    );
  }
}
