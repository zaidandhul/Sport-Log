import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_helper.dart';
import '../models/activity.dart';

class EditActivity extends StatefulWidget {
  final Activity activity;

  const EditActivity({super.key, required this.activity});

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _typeController;
  late TextEditingController _durationController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai awal dari activity
    _typeController = TextEditingController(text: widget.activity.type);
    _durationController = TextEditingController(text: widget.activity.duration.toString());
    _dateController = TextEditingController(text: widget.activity.date);
  }

  @override
  void dispose() {
    _typeController.dispose();
    _durationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedActivity = Activity(
        id: widget.activity.id,
        type: _typeController.text,
        duration: int.parse(_durationController.text),
        date: _dateController.text,
      );

      try {
        await Provider.of<DatabaseHelper>(context, listen: false)
            .insertActivity(updatedActivity); // Gunakan insert untuk replace
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aktivitas berhasil diperbarui')),
        );
        Navigator.pop(context); // Kembali ke layar sebelumnya
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui aktivitas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10B981), // Sesuaikan dengan tema
        title: const Text('Edit Aktivitas'),
        leading: IconButton(
          icon: Image.network(
            'https://cdn-icons-png.freepik.com/256/10024/10024483.png?ga=GA1.1.1296858242.1742907295&semt=ais_hybrid',
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.arrow_back),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Aktivitas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis aktivitas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Durasi (menit)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Durasi wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Durasi harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (YYYY-MM-DD)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal wajib diisi';
                  }
                  // Validasi sederhana untuk format tanggal (bisa diperluas)
                  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                    return 'Format tanggal harus YYYY-MM-DD';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}