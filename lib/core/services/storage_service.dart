import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _imagePicker = ImagePicker();

  /// Sube una imagen desde la galería o cámara
  static Future<String?> uploadImage({
    required String folder,
    String? fileName,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image == null) return null;

      return await _uploadFile(
        File(image.path),
        folder,
        fileName ?? path.basename(image.path),
      );
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  /// Sube un video desde la galería
  static Future<String?> uploadVideo({
    required String folder,
    String? fileName,
  }) async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 30),
      );

      if (video == null) return null;

      return await _uploadFile(
        File(video.path),
        folder,
        fileName ?? path.basename(video.path),
      );
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

  /// Sube un archivo genérico
  static Future<String?> _uploadFile(
    File file,
    String folder,
    String fileName,
  ) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  /// Elimina un archivo del storage
  static Future<bool> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  /// Genera un nombre único para el archivo
  static String generateUniqueFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(originalName);
    final nameWithoutExtension = path.basenameWithoutExtension(originalName);
    return '${nameWithoutExtension}_$timestamp$extension';
  }
}
