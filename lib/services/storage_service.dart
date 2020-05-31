import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final StorageReference _profilePicturesReference = FirebaseStorage.instance.ref().child('profilePics');
  final StorageReference _certificateReference = FirebaseStorage.instance.ref().child('certificatePics');

  Future<String> uploadProfilePicture(File picture) async {
    return await _upload(_profilePicturesReference, picture, 'jpg');
  }

  Future<String> uploadCertificate(File certificate) async {
    return await _upload(_certificateReference, certificate, 'jpg');
  }

  Future<String> _upload(StorageReference reference, File file, String extension) async {
    final id = _generateId();
    final StorageUploadTask task = reference.child('$id.$extension').putFile(file);
    final StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

  String _generateId() {
    return Uuid().v1();
  }
}
