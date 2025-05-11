import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_helper.dart';
import '../models/activity.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void dispose() {
    _durationController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  double _hitungKalori(String type, int duration) {
    final kaloriPerMenit = {
      'Lari': 10,
      'Bersepeda': 8,
      'Renang': 9,
      'Yoga': 4,
    };
    return (kaloriPerMenit[type] ?? 5) * duration.toDouble();
  }

  Future<void> _saveActivity() async {
    if (_formKey.currentState!.validate()) {
      final type = _typeController.text;
      final duration = int.parse(_durationController.text);
      final kalori = _hitungKalori(type, duration);

      final activity = Activity(
        id: 0,
        type: type,
        duration: duration,
        date: DateTime.now().toIso8601String(),
      );

      try {
        await Provider.of<DatabaseHelper>(context, listen: false).insertActivity(activity);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Aktivitas Tersimpan'),
            content: Text('Kalori yang terbakar: ${kalori.toStringAsFixed(2)} kalori'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan aktivitas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C4B4),
        title: const Text('Tambah Aktivitas'),
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
          child: Column(
            children: [
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Aktivitas',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C4B4),
                ),
                child: const Text('Simpan Aktivitas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}