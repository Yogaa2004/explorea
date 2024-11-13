import 'package:flutter/material.dart';
import 'explore_page.dart'; // Pastikan untuk mengimpor halaman ExplorePage
import 'profile_page.dart'; // Pastikan untuk mengimpor halaman AdminProfilePage

class AdminMasterHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Beranda Utama',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial', // Ganti font sesuai keinginan
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Headline berwarna hitam
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Bagian tengah berwarna putih
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Data
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.data_usage, size: 50, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExplorePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Data',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Arial', // Ganti font sesuai keinginan
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 60),
              // Icon Profil
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.person, size: 50, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminProfilePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Profil',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Arial', // Ganti font sesuai keinginan
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
