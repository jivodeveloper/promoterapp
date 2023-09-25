import 'package:promoterapp/models/Item.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE SKU(
        itemID INTEGER,
        itemName TEXT,
        quantity TEXT,
        piecesPerCase INTEGER,
        itemTypeId INTEGER,
        options TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'PromoterApp.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertdata(List<Item> skulist) async {

    final db = await DatabaseHelper.db();
    var id;

    for (var item in skulist) {
      id = await db.insert('SKU', item.toJson());
    }

     return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('SKU');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title, String? descrption) async {
    final db = await DatabaseHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
     // debugPrint("Something went wrong when deleting an item: $err");
    }
  }

}