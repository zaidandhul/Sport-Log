import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_helper.dart';
import '../models/community.dart';

class AddCommunity extends StatefulWidget {
  const AddCommunity({super.key});

  @override
  _AddCommunityState createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sportTypeController = TextEditingController();
  final _locationController = TextEditingController();
  final _scheduleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _sportTypeController.dispose();
    _locationController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  Future<void> _saveCommunity() async {
    if (_formKey.currentState!.validate()) {
      final community = Community(
        id: 0, // ID akan diatur oleh database
        name: _nameController.text,
        sportType: _sportTypeController.text,
        location: _locationController.text,
        schedule: _scheduleController.text,
      );
      try {
        await Provider.of<DatabaseHelper>(context, listen: false).insertCommunity(community);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Komunitas berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan komunitas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C4B4), // Warna hijau AppBar
        title: const Text('Tambah Komunitas'),
        leading: IconButton(
          icon: Image.network(
            'https://cdn-icons-png.freepik.com/256/10024/10024483.png?ga=GA1.1.1296858242.1742907295&semt=ais_hybrid', // URL ikon back biru dengan panah putih
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.arrow_back),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Komunitas',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama komunitas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sportTypeController,
                decoration: const InputDecoration(labelText: 'Jenis Olahraga'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis olahraga wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduleController,
                decoration: const InputDecoration(labelText: 'Jadwal (contoh: Sabtu, 07:00)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jadwal wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCommunity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C4B4), // Warna hijau tombol
                ),
                child: const Text('Simpan Komunitas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}