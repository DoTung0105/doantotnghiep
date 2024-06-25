import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final uuid = Uuid();

  Future<String> uploadImage(File image, String userId) async {
    try {
      String fileName = '${uuid.v4()}.jpg'; // Tạo tên tệp duy nhất
      TaskSnapshot snapshot =
          await _storage.ref().child('users/$userId/$fileName').putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }
}
