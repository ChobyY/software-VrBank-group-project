import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_accounts.json');
  }

  static Future<void> writeAll(List<dynamic> data) async {
    final file = await _localFile;
    await file.writeAsString(json.encode(data));
  }

  static Future<List<dynamic>> read() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        return json.decode(contents);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
