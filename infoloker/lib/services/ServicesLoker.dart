import 'package:cloud_firestore/cloud_firestore.dart';

class LokerService {
  Future<List<Map<String, dynamic>>> getLoker() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('loker').get();
      List<Map<String, dynamic>> dataListServices = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data();
        if (data != null) {
          dataListServices.add({
            'urlimage': data['urlimage'],
            'title': data['title'],
            'deskripsi': data['deskripsi'],
            'alamat': data['alamat'],
            'tanggal': data['tanggal']
          });
        }
      });
      return dataListServices;
    } catch (error) {
      throw error;
    }
  }
}
