import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> getDb() async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    String dbPath = join(await getDatabasesPath(), 'card_organizer.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Create folders table
        await db.execute('''
          CREATE TABLE folders(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');

        // Create cards table
        await db.execute('''
          CREATE TABLE cards(
            id INTEGER PRIMARY KEY,
            folderId INTEGER,
            value TEXT,
            imageUrl TEXT,
            FOREIGN KEY(folderId) REFERENCES folders(id)
          )
        ''');

        // Insert folder data (suits)
        await db.insert('folders', {'name': 'Hearts'});
        await db.insert('folders', {'name': 'Clubs'});
        await db.insert('folders', {'name': 'Diamonds'});
        await db.insert('folders', {'name': 'Spades'});

        // Fill cards table
        await _populateCards(db);
      },
    );
  }

  static Future<void> _populateCards(Database db) async {
    List<String> suits = ['Hearts', 'Clubs', 'Diamonds', 'Spades'];
    List<String> values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];

    // 14 playing card image URLs; these sample URLs use a popular public domain deck from Wikimedia
    List<String> imageUrls = [
      'https://upload.wikimedia.org/wikipedia/commons/5/57/Playing_card_spade_A.svg',
      'https://upload.wikimedia.org/wikipedia/commons/d/d5/Playing_card_spade_2.svg',
      'https://upload.wikimedia.org/wikipedia/commons/2/21/Playing_card_spade_3.svg',
      'https://upload.wikimedia.org/wikipedia/commons/f/f2/Playing_card_spade_4.svg',
      'https://upload.wikimedia.org/wikipedia/commons/8/87/Playing_card_spade_5.svg',
      'https://upload.wikimedia.org/wikipedia/commons/2/2c/Playing_card_spade_6.svg',
      'https://upload.wikimedia.org/wikipedia/commons/8/88/Playing_card_spade_7.svg',
      'https://upload.wikimedia.org/wikipedia/commons/e/e0/Playing_card_spade_8.svg',
      'https://upload.wikimedia.org/wikipedia/commons/8/86/Playing_card_spade_9.svg',
      'https://upload.wikimedia.org/wikipedia/commons/8/87/Playing_card_spade_10.svg',
      'https://upload.wikimedia.org/wikipedia/commons/8/81/Playing_card_spade_J.svg',
      'https://upload.wikimedia.org/wikipedia/commons/b/bd/Playing_card_spade_Q.svg',
      'https://upload.wikimedia.org/wikipedia/commons/2/25/Playing_card_spade_K.svg',
      'https://upload.wikimedia.org/wikipedia/commons/5/57/Playing_card_back_01.svg'
    ];

    for (int suitIndex = 0; suitIndex < suits.length; suitIndex++) {
      int folderId = suitIndex + 1; // Folder IDs start from 1
      for (int valueIndex = 0; valueIndex < values.length; valueIndex++) {
        String cardValue = '${values[valueIndex]} of ${suits[suitIndex]}';
        String imageUrl = imageUrls[valueIndex % imageUrls.length]; // Cycle through actual links

        await db.insert('cards', {
          'folderId': folderId,
          'value': cardValue,
          'imageUrl': imageUrl,
        });
      }
    }
  }
}
