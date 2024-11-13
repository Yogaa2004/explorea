import 'package:flutter/material.dart';
import '../model/data_wisata.dart'; // Pastikan path ini benar

class DaftarWisata extends StatelessWidget {
  final DataWisata wisata;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DaftarWisata({
    Key? key,
    required this.wisata,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        leading: Image.network(
          wisata.gambarUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(wisata.nama),
        subtitle: Text(wisata.deskripsi),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
