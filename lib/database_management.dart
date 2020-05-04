import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'quote.dart';
import 'file_management.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String quoteTable = 'quote_table';
  String colId = 'id';
  String colAuthor = 'author';
  String colQuote = 'quote';
  String colDate = 'date';
  String colSaved = 'saved';
  String colTimesSeen = 'times_seen';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'quoteDatabase.db';

    print("Initializing Database");

    // Open/create the database at a given path
    var quotesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return quotesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db
        .execute(
            'CREATE TABLE $quoteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colAuthor TEXT, '
            '$colQuote TEXT, $colDate TEXT, $colSaved INTEGER, $colTimesSeen INTEGER)')
        .then((_) {
      _addQuotesToDB();
    });

    print("Created Database");
  }

  void _addQuotesToDB() async {
    FileManagement.readFileLines('assets/data/quotes.txt')
        .then((List<Quote> allQuotes) {
      for (int i = 0; i < allQuotes.length; i++) {
        insertQuote(allQuotes.elementAt(i));
      }
    });
  }

  // Fetch Operation: Get all quote objects from database
  Future<List<Map<String, dynamic>>> getQuoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $quoteTable order by $colTitle ASC');
    var result = await db.query(quoteTable, orderBy: '$colAuthor ASC');
    return result;
  }

  // Insert Operation: Insert a quote object to database
  Future<int> insertQuote(Quote quote) async {
    Database db = await this.database;
    var result = await db.insert(quoteTable, quote.toMap());
    return result;
  }

  // Delete Operation: Delete a quote object from database
  Future<int> deleteQuote(int id) async {
    var db = await this.database;
    int result = await db
        .rawDelete("DELETE FROM $quoteTable WHERE $colId=$id");
    return result;
  }

  // Get number of quote objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $quoteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'quote List' [ List<Quote> ]
  Future<List<Quote>> getQuoteList() async {
    var quoteMapList = await getQuoteMapList(); // Get 'Map List' from database
    int count =
        quoteMapList.length; // Count the number of map entries in db table

    List<Quote> quoteList = List<Quote>();
    // For loop to create a 'quote List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      quoteList.add(Quote.fromMapObject(quoteMapList[i]));
    }

    return quoteList;
  }

  // Fetch Operation: Get all quote objects from database
  Future<List<Map<String, dynamic>>> getSavedQuoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $quoteTable order by $colTitle ASC');
    var queryResult = await db.rawQuery(
        'SELECT * FROM $quoteTable WHERE $colSaved=1');
    return queryResult;
  }

  Future<List<Quote>> getSavedQuotes() async {
    var quoteMapList =
        await getSavedQuoteMapList(); // Get 'Map List' from database
    int count =
        quoteMapList.length; // Count the number of map entries in db table

    List<Quote> quoteList = List<Quote>();
    // For loop to create a 'quote List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      quoteList.add(Quote.fromMapObject(quoteMapList[i]));
    }

    return quoteList;
  }

  Future<void> saveQuote(int id) async {
    Database db = await this.database;

    await db.rawQuery(
        "UPDATE $quoteTable SET $colSaved=1 WHERE $colId=$id");
  }

  Future<void> unsaveQuote(int id) async {
    Database db = await this.database;

    await db.rawQuery(
        "UPDATE $quoteTable SET $colSaved=0 WHERE $colId=$id");
  }

  Future<bool> isQuoteSaved(int id) async {
    Database db = await this.database;
    Quote grabbedQuote = Quote("", "", 0);

//		var result = await db.rawQuery('SELECT * FROM $quoteTable order by $colTitle ASC');
    var queryResult = await db.rawQuery(
        "SELECT * FROM $quoteTable WHERE $colSaved=1 AND $colId=$id");
      

    if (queryResult.length > 0) grabbedQuote = Quote.fromMapObject(queryResult[0]);

    if (grabbedQuote.saved == null)
      return false;

    return (grabbedQuote.saved == 1);
  }

  Future<Quote> getRandomQuote() async {
    Database db = await this.database;
    Quote quote = Quote("", "", 0);

    var queryResult = await db
        .rawQuery('SELECT * FROM $quoteTable order by RANDOM() LIMIT 1');

    if (queryResult.length > 0) quote = Quote.fromMapObject(queryResult[0]);

    return quote;
  }
}
