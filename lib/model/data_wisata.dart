import 'package:cloud_firestore/cloud_firestore.dart';

class DataWisata {
  String id;
  String nama;
  String deskripsi;
  String kategori;
  String area;
  double rating;
  String gambarUrl;
  final DateTime? createdAt;
  final DateTime? addedToWishlistAt; // Tambahkan ini

  DataWisata({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.kategori,
    required this.area,
    required this.rating,
    required this.gambarUrl,
    this.createdAt,
    this.addedToWishlistAt,
  });

  // Membuat instance DataWisata dari dokumen Firestore dengan null safety dan validasi
  factory DataWisata.fromDocument(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      print('Processing document: ${doc.id}');
      print('Category: ${data['kategori']}');
      
      return DataWisata(
        id: doc.id,
        nama: data['nama'] ?? 'Nama tidak tersedia',
        deskripsi: data['deskripsi'] ?? 'Deskripsi tidak tersedia',
        kategori: data['kategori'] ?? 'Kategori tidak tersedia',
        area: data['area'] ?? 'Area tidak tersedia',
        rating: (data['rating'] ?? 0.0).toDouble(),
        gambarUrl: data['gambarUrl'] ?? '',
        createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(), // Default ke waktu sekarang jika null
        addedToWishlistAt: data['addedToWishlistAt'] != null 
          ? (data['addedToWishlistAt'] as Timestamp).toDate() 
          : null,

      );
    } catch (e) {
      print('Error parsing document: $e');
      throw Exception('Failed to parse DataWisata');
    }
  }


  // Mengubah instance DataWisata ke Map agar bisa disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'area': area,
      'rating': rating,
      'gambarUrl': gambarUrl,
    };
  }
}
