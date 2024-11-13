import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../model/data_wisata.dart';

class HapusDataPage extends StatelessWidget {
  final DataWisata wisata;
  final FirestoreService _firestoreService = FirestoreService();

  HapusDataPage({Key? key, required this.wisata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Untuk memposisikan judul di tengah
        title: const Text(
          'Hapus Data Wisata',
          style: TextStyle(color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.black, // Warna headline hitam
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon "Back" menjadi putih
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus "${wisata.nama}"?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _firestoreService.hapus(
                    collectionPath: 'data_wisata',
                    id: wisata.id,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil dihapus')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menghapus data')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna tombol "Hapus" merah
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(fontSize: 18, color: Colors.white), // Warna teks putih
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(fontSize: 16, color: Colors.black), // Warna teks "Batal" hitam
              ),
            ),
          ],
        ),
      ),
    );
  }
}
