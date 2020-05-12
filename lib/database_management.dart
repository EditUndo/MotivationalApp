import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:math';
import 'quote.dart';
import 'file_management.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  final databaseReference = Firestore.instance;
  final _random = new Random();

  void getData() {
    databaseReference
        .collection("quotes")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  Future<Quote> getRandomQuote() async {
    String quote = "";
    String author = "";
    String cloudId = "";
    QuerySnapshot snapshot = await databaseReference.collection("quotes").getDocuments();
    
    quote = snapshot.documents[_random.nextInt(snapshot.documents.length)].data.values.first.toString();
    author = snapshot.documents[_random.nextInt(snapshot.documents.length)].data.values.elementAt(1).toString();
    cloudId = snapshot.documents[_random.nextInt(snapshot.documents.length)].documentID;
    Quote result = new Quote(quote, author, cloudId);
    print(quote);
    return result;
  }

  static Database _database; // Singleton Database

  String quoteTable = 'saved_quotes';
  String colId = 'id';
  String colAuthor = 'author';
  String colQuote = 'quote';
  String colCloudId = "cloud_id";


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
		String path = directory.path + 'savedQuotes.db';

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
            '$colQuote TEXT, $colCloudId TEXT)')
        .then((_) {
    });

    print("Created Database");
  }

  // Fetch Operation: Get all quote objects from database
  Future<List<Map<String, dynamic>>> getQuoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $quoteTable order by $colTitle ASC');
    var result = await db.query(quoteTable, orderBy: '$colAuthor ASC');
    print(result);
    return result;
  }

  // Insert Operation: Insert a quote object to database
  Future<int> insertQuote(Quote quote) async {
    Database db = await this.database;
    var result = await db.insert(quoteTable, quote.toMap());
    return result;
  }

  // Delete Operation: Delete a quote object from database
  Future<int> deleteQuote(String cloudId) async {
    var db = await this.database;
    int result = await db.rawDelete("DELETE FROM $quoteTable WHERE $colCloudId=$cloudId");
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

  Future<bool> isQuoteSaved(String cloudId) async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $quoteTable order by $colTitle ASC');
    var queryResult = await db
        .rawQuery("SELECT * FROM $quoteTable");

    return queryResult.contains(cloudId);
  }
}
