import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

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

}