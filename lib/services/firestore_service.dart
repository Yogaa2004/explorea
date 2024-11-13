import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coba/model/data_wisata.dart';
import 'package:rxdart/rxdart.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CRUD Operations
  Future<void> tambah({
    required String collectionPath,
    required Map<String, dynamic> item,
  }) async {
    try {
      item['createdAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(collectionPath).add(item);
    } catch (e) {
      print('Error adding document: $e');
      rethrow;
    }
  }

  Future<void> update({
    required String collectionPath,
    required String id,
    required Map<String, dynamic> item,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(id).update(item);
    } catch (e) {
      print('Error updating document: $e');
      rethrow;
    }
  }

  Future<void> hapus({
    required String collectionPath,
    required String id,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
    } catch (e) {
      print('Error deleting document: $e');
      rethrow;
    }
  }

  Stream<List<T>> getList<T>({
    required String collectionPath,
    required T Function(DocumentSnapshot doc) fromMap,
  }) {
    return _firestore.collection(collectionPath).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => fromMap(doc)).toList(),
        );
  }

  Future<T> getById<T>({
    required String collectionPath,
    required String id,
    required T Function(DocumentSnapshot doc) fromMap,
  }) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionPath).doc(id).get();
      return fromMap(doc);
    } catch (e) {
      print('Error getting document: $e');
      rethrow;
    }
  }

  // Wisata Operations
  Stream<List<DataWisata>> getWisataByCategory(String category) {
    return _firestore
        .collection('data_wisata')
        .where('kategori', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DataWisata.fromDocument(doc))
          .toList();
    });
  }

  // Wishlist Operations
  Future<bool> isInWishlist(String wisataId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(wisataId)
        .get();

    return doc.exists;
  }

  Future<void> addToWishlist(DataWisata wisata) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(wisata.id)
        .set({
          'wisataId': wisata.id,
          'nama': wisata.nama,
          'gambarUrl': wisata.gambarUrl,
          'area': wisata.area,
          'rating': wisata.rating,
          'kategori': wisata.kategori,
          'addedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> removeFromWishlist(String wisataId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(wisataId)
        .delete();
  }

  Stream<List<DataWisata>> getWishlist() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return DataWisata(
              id: doc.id,
              nama: data['nama'] ?? '',
              deskripsi: '',
              kategori: data['kategori'] ?? '',
              area: data['area'] ?? '',
              rating: (data['rating'] ?? 0.0).toDouble(),
              gambarUrl: data['gambarUrl'] ?? '',
            );
          }).toList();
        });
  }

  Stream<List<DataWisata>> getWishlistItems() {
    return getWishlist(); // Use existing getWishlist method
  }

  Stream<List<DataWisata>> sortWishlistByDate() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DataWisata.fromDocument(doc))
            .toList());
  }

  Stream<List<DataWisata>> sortWishlistByRating() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DataWisata.fromDocument(doc))
            .toList());
  }

  Stream<List<DataWisata>> sortWishlistByName() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .orderBy('nama')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DataWisata.fromDocument(doc))
            .toList());
  }

  Stream<List<DataWisata>> getWisataByRating() {
    return _firestore
    .collection('data_wisata')
    .orderBy('rating', descending: true)
    .snapshots()
    .map((snapshot) {
      return snapshot.docs
        .map((doc) => DataWisata.fromDocument(doc))
        .toList();
    }); 
  }

  Stream<List<DataWisata>> getWisataTerbaru() {
  // Ambil tanggal 7 hari yang lalu
  final DateTime oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
  
  return _firestore
    .collection('data_wisata')
    .where('createdAt', isGreaterThanOrEqualTo: oneWeekAgo)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) {
      print('Jumlah wisata baru: ${snapshot.docs.length}'); // Debug print
      return snapshot.docs
        .map((doc) => DataWisata.fromDocument(doc))
        .toList();
    });
  }

  Stream<List<String>> getUniqueAreas() {
    return _firestore
      .collection('data_wisata')
      .snapshots()
      .map((snapshot) {
        final areas = snapshot.docs
          .map((doc) => doc.data()['area'] as String)
          .toSet()
          .toList();
        return areas;
      });
  }

  Stream<int> getWisataCountByArea(String area) {
    return _firestore
      .collection('data_wisata')
      .where('area', isEqualTo: area)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<DataWisata>> getLatestWishlist() {
  return _firestore
    .collection('wishlists')
    .orderBy('addedToWishlistAt', descending: true)
    .limit(5)
    .snapshots()
    .map((snapshot) => snapshot.docs
      .map((doc) => DataWisata.fromDocument(doc))
      .toList());
}

Future<void> addWisata(DataWisata wisata) {
  return _firestore.collection('data_wisata').add({
    'nama': wisata.nama,
    'deskripsi': wisata.deskripsi,
    'gambarUrl': wisata.gambarUrl,
    'area': wisata.area,
    'kategori': wisata.kategori,
    'rating': wisata.rating,
    'createdAt': FieldValue.serverTimestamp(), // Tambahkan ini
  });
}

Stream<int> getTotalNotifications() {
  return Rx.combineLatest2(
    getWisataTerbaru(),
    getLatestWishlist(),
    (List<DataWisata> wisata, List<DataWisata> wishlist) => 
      wisata.length + wishlist.length
  );
}



  getWishlistStream() {}





}

