import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileUtils {
  static Future<String> getAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> getBooksDirectory() async {
    final appDir = await getAppDirectory();
    final booksDir = Directory(path.join(appDir, 'books'));
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }
    return booksDir.path;
  }

  static Future<String> getCoversDirectory() async {
    final appDir = await getAppDirectory();
    final coversDir = Directory(path.join(appDir, 'covers'));
    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }
    return coversDir.path;
  }

  static Future<String> saveBookFile(File file) async {
    final booksDir = await getBooksDirectory();
    final fileName = path.basename(file.path);
    final newPath = path.join(booksDir, fileName);
    await file.copy(newPath);
    return newPath;
  }

  static Future<String> saveCoverImage(File image) async {
    final coversDir = await getCoversDirectory();
    final fileName = path.basename(image.path);
    final newPath = path.join(coversDir, fileName);
    await image.copy(newPath);
    return newPath;
  }

  static Future<void> deleteBook(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> deleteCover(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<List<String>> getBookFiles() async {
    final booksDir = await getBooksDirectory();
    final directory = Directory(booksDir);
    final files = await directory.list().toList();
    return files
        .where((entity) => entity is File)
        .map((entity) => entity.path)
        .where((path) => path.endsWith('.epub') || path.endsWith('.pdf'))
        .toList();
  }

  static Future<List<String>> getCoverFiles() async {
    final coversDir = await getCoversDirectory();
    final directory = Directory(coversDir);
    final files = await directory.list().toList();
    return files
        .where((entity) => entity is File)
        .map((entity) => entity.path)
        .where((path) => path.endsWith('.jpg') || path.endsWith('.png'))
        .toList();
  }

  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  static String getFileName(String filePath) {
    return path.basename(filePath);
  }

  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }
}