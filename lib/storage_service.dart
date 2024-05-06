import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<void> writeData(String data) async {
    final file = await _localFile;
    await file.writeAsString(data, mode: FileMode.append);
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return 'Error reading file: $e';
    }
  }
}
