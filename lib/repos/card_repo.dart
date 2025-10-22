import 'package:sqflite/sqflite.dart';
import '../db_helper.dart';
import '../models/card.dart';

class CardRepo {
  Future<List<CardModel>> getCardsByFolder(int folderId) async {
    final db = await DBHelper.getDb();
    final res = await db.query('cards', where: 'folderId = ?', whereArgs: [folderId]);
    return res.map((c) => CardModel.fromMap(c)).toList();
  }

  Future<void> insertCard(CardModel card) async {
    final db = await DBHelper.getDb();
    await db.insert('cards', card.toMap());
  }

  Future<void> deleteCard(int id) async {
    final db = await DBHelper.getDb();
    await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }
}
