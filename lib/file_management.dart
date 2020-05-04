import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'quote.dart';

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

  static Future<List<Quote>> readFileLines(String fileName) async {
    String fullText = await rootBundle.loadString(fileName);
    List<String> lines = fullText.split("\n");
    List<Quote> quotes = List<Quote>();
    for (int i = 0; i < lines.length; i++) {
      List<String> splitQuote = lines.elementAt(i).split("-");
      if (splitQuote.length == 2) {
        String quoteText = splitQuote[0];
        String authorText = splitQuote[1];
        quotes.add(Quote(quoteText, authorText, 0));
      }
    }

    return quotes;
  }
}
