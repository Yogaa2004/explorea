import 'package:coba/services/firestore_service.dart';
import 'package:flutter/material.dart';
import '../../model/data_wisata.dart';

class UpdateDataPage extends StatefulWidget {
  final DataWisata wisata;

  const UpdateDataPage({Key? key, required this.wisata}) : super(key: key);

  @override
  _UpdateDataPageState createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _areaController;
  late TextEditingController _ratingController;
  late TextEditingController _gambarUrlController;

  final FirestoreService _firestoreService = FirestoreService();

  // Daftar kategori dan variabel untuk menampung kategori yang dipilih
  final List<String> _kategoriList = [
    'alam', 'shopping', 'kuliner', 'budaya', 'pantai', 'taman', 'hiburan', 'event'
  ];
  String? _selectedKategori;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.wisata.nama);
    _deskripsiController = TextEditingController(text: widget.wisata.deskripsi);
    _selectedKategori = widget.wisata.kategori; // Menyimpan kategori yang sudah ada
    _areaController = TextEditingController(text: widget.wisata.area);
    _ratingController = TextEditingController(text: widget.wisata.rating.toString());
    _gambarUrlController = TextEditingController(text: widget.wisata.gambarUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Untuk memposisikan judul di tengah
        title: const Text(
          'Update Data Wisata',
          style: TextStyle(color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.black, // Warna headline hitam
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon "Back" menjadi putih
      ),
      body: Container(
        color: const Color(0xFFF2F2F2),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_namaController, 'Nama Wisata'),
              const SizedBox(height: 10),
              _buildTextField(_deskripsiController, 'Deskripsi'),
              const SizedBox(height: 10),
              _buildDropdownKategori(),
              const SizedBox(height: 10),
              _buildTextField(_areaController, 'Area'),
              const SizedBox(height: 10),
              _buildTextField(_ratingController, 'Rating', isNumeric: true),
              const SizedBox(height: 10),
              _buildTextField(_gambarUrlController, 'URL Gambar'),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Warna kotak tombol menjadi hitam
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _updateData,
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 18, color: Colors.white), // Warna teks menjadi putih
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field ini wajib diisi';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownKategori() {
    return DropdownButtonFormField<String>(
      value: _selectedKategori,
      hint: const Text("Pilih Kategori"),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange, width: 1.5),
        ),
      ),
      items: _kategoriList.map((kategori) {
        return DropdownMenuItem(
          value: kategori,
          child: Text(kategori),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedKategori = value;
        });
      },
      validator: (value) => value == null ? 'Pilih kategori' : null,
    );
  }

  void _updateData() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = {
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'kategori': _selectedKategori,
        'area': _areaController.text,
        'rating': double.tryParse(_ratingController.text) ?? 0.0,
        'gambarUrl': _gambarUrlController.text,
      };

      try {
        await _firestoreService.update(
          collectionPath: 'data_wisata',
          id: widget.wisata.id,
          item: updatedItem,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data')),
        );
      }
    }
  }
}
