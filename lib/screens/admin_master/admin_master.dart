import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMasterPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleBlockStatus(String adminId, bool isBlocked) async {
    await _firestore.collection('users').doc(adminId).update({
      'isBlocked': !isBlocked,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Admin',
          style: TextStyle(
            color: Colors.white,  // White text color
            fontSize: 20,  // Adjust font size as needed
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',  // Bold for emphasis
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,  // Center the title
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada admin yang terdaftar'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var adminData = snapshot.data!.docs[index];
                String adminId = adminData.id;
                String adminName = (adminData.data() as Map<String, dynamic>).containsKey('name')
                    ? adminData['name']
                    : 'Nama tidak tersedia';
                bool isBlocked = (adminData.data() as Map<String, dynamic>).containsKey('isBlocked')
                    ? adminData['isBlocked']
                    : true;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      adminName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      isBlocked ? 'Diblokir' : 'Aktif',
                      style: TextStyle(
                        color: isBlocked ? Colors.red : Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        toggleBlockStatus(adminId, isBlocked);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBlocked
                            ? Colors.green
                            : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(isBlocked ? 'Buka Blokir' : 'Blokir'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
