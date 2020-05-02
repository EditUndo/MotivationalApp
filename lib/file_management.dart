import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FileManagement {

  static Future<String> readRandomFileLine(String fileName) async {
    String fullText = await rootBundle.loadString(fileName);
    List<String> lines = fullText.split("\n");

    Random _random = new Random();

    return lines[_random.nextInt(lines.length)];
  }

  static Future<String> readFile(String fileName) async {
    return await rootBundle.loadString(fileName);
  }

/*
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),
  );
*/

}