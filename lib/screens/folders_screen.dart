import 'package:flutter/material.dart';
import '../repos/folder_repo.dart';
import '../models/folder.dart';
import 'cards_screen.dart'; // For navigation

class FoldersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Folders')),
      body: FutureBuilder<List<Folder>>(
        future: FolderRepo().getAllFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No folders found.'));
          }
          final folders = snapshot.data!;
          return ListView.builder(
            itemCount: folders.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(folders[index].name),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CardsScreen(folder: folders[index])
                ));
              }
            ),
          );
        },
      ),
    );
  }
}
