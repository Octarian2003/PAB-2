import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:info_loker_pab/models/loker.dart';
import 'package:path/path.dart' as path;

class LokerService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _lokersCollection =
      _database.collection('lokers');
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  //Tambah Data
  static Future<void> addLoker(Loker loker) async {
    Map<String, dynamic> newloker = {
      'title': loker.title,
      'alamat': loker.alamat,
      'deskripsi': loker.deskripsi,
      'tanggal': loker.tanggal,
      'urlimage': loker.urlimage,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _lokersCollection.add(newloker);
  }

  //Menampilkan data
  static Stream<List<Loker>> getLokerList() {
    return _lokersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Loker(
          id: doc.id,
          title: data['title'],
          deskripsi: data['deskripsi'],
          alamat: data['alamat'],
          tanggal: data['tanggal'],
          urlimage: data['urlimage'],
          createdAt: data['created_at'] != null
              ? data['created_at'] as Timestamp
              : null,
          updatedAt: data['updated_at'] != null
              ? data['updated_at'] as Timestamp
              : null,
        );
      }).toList();
    });
  }

  //Ubah data
  static Future<void> updateLoker(Loker loker) async {
    Map<String, dynamic> updatedLoker = {
      'title': loker.title,
      'alamat': loker.alamat,
      'deskripsi': loker.deskripsi,
      'tanggal': loker.tanggal,
      'urlimage': loker.urlimage,
      'created_at': loker.createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };
    await _lokersCollection.doc(loker.id).update(updatedLoker);
  }

  //hapus data
  static Future<void> deleteNote(Loker loker) async {
    await _lokersCollection.doc(loker.id).delete();
  }
  //upload image
  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference ref = _storage.ref().child('image/$fileName');
      UploadTask uploadTask;
       if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(io.File(imageFile.path));
      }
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}