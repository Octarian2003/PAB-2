import 'package:cloud_firestore/cloud_firestore.dart';

class Loker {
  String? id;
  final String title;
  final String alamat;
  final String deskripsi;
  final String tanggal;
  String? urlimage;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Loker({
    this.id,
    required this.title,
    required this.alamat,
    required this.deskripsi,
    required this.tanggal,
    this.urlimage,
    this.createdAt,
    this.updatedAt,
  });

  factory Loker.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Loker(
      id: doc.id,
      title: data['title'],
      alamat: data['alamat'],
      deskripsi: data['deskripsi'],
      tanggal: data['date'],
      urlimage: data['image_url'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'alamat': alamat,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'urlimage': urlimage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
