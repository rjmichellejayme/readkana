import 'dart:io';
import 'dart:ui' as ui;
import 'package:pdfx/pdfx.dart';
import 'package:epubx/epubx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class BookProcessorService {
  static Future<Map<String, dynamic>> processBook(String filePath) async {
    final fileExtension = path.extension(filePath).toLowerCase();

    try {
      switch (fileExtension) {
        case '.pdf':
          return await _processPDF(filePath);
        case '.epub':
          return await _processEPUB(filePath);
        default:
          throw UnsupportedError('Unsupported file format: $fileExtension');
      }
    } catch (e) {
      throw BookProcessingException('Error processing book: $e');
    }
  }

  static Future<Map<String, dynamic>> _processPDF(String filePath) async {
    final file = File(filePath);
    final document = await PdfDocument.openFile(filePath);

    try {
      final coverImage = await _extractPDFCover(document);
      final coverPath = coverImage != null
          ? await _saveCoverImage(coverImage, filePath)
          : null;

      return {
        'title': path.basenameWithoutExtension(filePath),
        'author': null,
        'totalPages': document.pagesCount,
        'coverPath': coverPath,
        'fileType': 'pdf',
        'fileSize': await file.length(),
        'description': null,
      };
    } finally {
      document.close();
    }
  }

  static Future<File?> _extractPDFCover(PdfDocument document) async {
    try {
      final firstPage = await document.getPage(1);
      final pageImage = await firstPage.render(
        width: 400,
        height: 600,
      );

      if (pageImage != null) {
        final tempDir = await getTemporaryDirectory();
        final coverFile = File('${tempDir.path}/temp_cover.jpg');
        await coverFile.writeAsBytes(pageImage.bytes);
        return coverFile;
      }
    } catch (e) {
      print('Error extracting PDF cover: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>> _processEPUB(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final book = await EpubReader.readBook(bytes);

    try {
      final coverImage = await _extractEPUBCover(book);
      final coverPath = coverImage != null
          ? await _saveCoverImage(coverImage, filePath)
          : null;

      return {
        'title': book.Title ?? path.basenameWithoutExtension(filePath),
        'author': book.Author,
        'totalPages': book.Chapters?.length ?? 0,
        'coverPath': coverPath,
        'fileType': 'epub',
        'fileSize': await file.length(),
      };
    } catch (e) {
      throw BookProcessingException('Error processing EPUB: $e');
    }
  }

  static Future<File?> _extractEPUBCover(EpubBook book) async {
    try {
      if (book.CoverImage != null) {
        final img.Image image =
            book.CoverImage!; // Use image.Image from the image package
        final tempDir = await getTemporaryDirectory();
        final coverFile = File('${tempDir.path}/temp_cover.jpg');
        await coverFile
            .writeAsBytes(img.encodeJpg(image)); // Encode the image as JPG
        return coverFile;
      }
    } catch (e) {
      print('Error extracting EPUB cover: $e');
    }
    return null;
  }

  static Future<String?> _saveCoverImage(
      File coverFile, String bookPath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final coverFileName =
          'cover_${path.basenameWithoutExtension(bookPath)}.jpg';
      final savedCover =
          await coverFile.copy('${appDir.path}/covers/$coverFileName');
      return savedCover.path;
    } catch (e) {
      print('Error saving cover image: $e');
      return null;
    }
  }
}

class BookProcessingException implements Exception {
  final String message;
  BookProcessingException(this.message);

  @override
  String toString() => message;
}
