
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notes/notes.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper{

    static Database? _db ;

    Future <Database?> get db async{
      if(_db != null){
        return _db;
      }

      _db = await intiDatabase();
      return _db;
    }

    intiDatabase() async{
    
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path , 'notes.db');
    var db = await openDatabase(path , version: 1 , onCreate: _onCreate);
    return db;

    }
    _onCreate (Database db , int version) async{
      await db.execute("CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT , title TEXT NOT NULL , age INTEGER NOT NULL , description TEXT NOT NULL , email TEXT)",);
    }

    Future<NotesModel> insert(NotesModel notesModel) async{
      var dbclient = await db ;
      await dbclient!.insert('notes', notesModel.toMap());

      return notesModel;
    }

    Future<List<NotesModel>> getnotesList () async {
      var dbclient = await db;
      final List<Map<String , Object?>> queryResult = await dbclient!.query('notes');
      return queryResult.map((e) => NotesModel.fromMap(e)).toList();

    }

    Future<int> delete(int id) async{
      var dbclient = await db;
      return await dbclient!.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
        
      );
    }

    Future<int> update(NotesModel notesModel) async{
      var dbclient = await db;
      return await dbclient!.update(
        'notes',
        notesModel.toMap(),
        where: 'id = ?',
        whereArgs: [notesModel.id]
        
      );
    }

}