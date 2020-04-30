import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileManagement {

  static String readRandomFileLine(String fileName) {
    final file = new File(fileName);
    final _random = new Random();

    List<String> lines = file.readAsLinesSync();
    
    return lines[_random.nextInt(lines.length)];
  }

}

