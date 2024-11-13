import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/data_wisata.dart';
import 'firestore_service.dart';

class WisataService {
  final FirestoreService _firestoreService = FirestoreService();
  final String collectionPath = 'data_wisata';

  Future<void> tambahWisata(DataWisata wisata) {
    return _firestoreService.tambah(
      collectionPath: collectionPath,
      item: wisata.toMap(),
    );
  }

  Future<void> updateWisata(DataWisata wisata) {
    return _firestoreService.update(
      collectionPath: collectionPath,
      id: wisata.id,
      item: wisata.toMap(),
    );
  }

  Future<void> hapusWisata(String id) {
    return _firestoreService.hapus(
      collectionPath: collectionPath,
      id: id,
    );
  }

  Stream<List<DataWisata>> getWisataList() {
    return _firestoreService.getList(
      collectionPath: collectionPath,
      fromMap: (doc) => DataWisata.fromDocument(doc),
    );
  }

  Future<DataWisata> getWisataById(String id) {
    return _firestoreService.getById(
      collectionPath: collectionPath,
      id: id,
      fromMap: (doc) => DataWisata.fromDocument(doc),
    );
  }
}
