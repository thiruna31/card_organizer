import '../db_helper.dart';
import '../models/folder.dart';

class FolderRepo {
  Future<List<Folder>> getAllFolders() async {
    final db = await DBHelper.getDb();
    final folderRes = await db.query('folders');
    List<Folder> folders = folderRes.map((f) => Folder.fromMap(f)).toList();

    for (var folder in folders) {
      
      final cardRes = await db.query('cards',
        where: 'folderId = ?',
        whereArgs: [folder.id],
        limit: 1
      );
      folder.previewImage = cardRes.isNotEmpty ? cardRes.first['imageUrl']?.toString() : '';


      
      final countRes = await db.rawQuery(
        'SELECT COUNT(*) as cnt FROM cards WHERE folderId = ?', [folder.id]
      );
      folder.cardCount = countRes.first['cnt'] as int;
    }

    return folders;
  }

 
}
