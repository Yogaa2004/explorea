import 'package:flutter/material.dart';
import 'tambah_data_page.dart';
import 'update_data_page.dart';
import 'hapus_data_page.dart';
import '../../services/firestore_service.dart';
import '../../model/data_wisata.dart';

class ExplorePage extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Warna ikon tombol "Back" menjadi putih
        ),
        title: const Text(
          'Halaman Data',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial', // Ganti sesuai keinginan
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Warna headline hitam
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<DataWisata>>(
          stream: _firestoreService.getList<DataWisata>(
            collectionPath: 'data_wisata',
            fromMap: (doc) => DataWisata.fromDocument(doc),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final dataWisata = snapshot.data ?? [];

            return ListView.builder(
              itemCount: dataWisata.length,
              itemBuilder: (context, index) {
                final wisata = dataWisata[index];
                return _buildTitleBox(context, wisata);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahDataPage()),
          );
        },
        child: const Icon(Icons.add, size: 28),
        backgroundColor: const Color.fromARGB(255, 188, 188, 188),
        elevation: 8,
      ),
    );
  }

  Widget _buildTitleBox(BuildContext context, DataWisata wisata) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Warna kotak putih
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Bayangan
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (wisata.gambarUrl != null && wisata.gambarUrl.isNotEmpty) // Periksa apakah URL gambar ada
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: NetworkImage(wisata.gambarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              wisata.nama,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              wisata.deskripsi,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateDataPage(wisata: wisata),
                      ),
                    );
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HapusDataPage(wisata: wisata),
                      ),
                    );
                  },
                  child: Text(
                    'Hapus',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
