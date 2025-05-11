import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_helper.dart';
import '../models/challenge.dart';

class AddChallenge extends StatefulWidget {
  const AddChallenge({super.key});

  @override
  _AddChallengeState createState() => _AddChallengeState();
}

class _AddChallengeState extends State<AddChallenge> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveChallenge() async {
    if (_formKey.currentState!.validate()) {
      try {
        final challenge = Challenge(
          id: 0,
          name: _nameController.text,
          description: _descriptionController.text,
          target: int.parse(_targetController.text),
          duration: _durationController.text,
        );
        debugPrint('Saving challenge: $challenge');
        await Provider.of<DatabaseHelper>(context, listen: false).insertChallenge(challenge);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tantangan berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } catch (e) {
        debugPrint('Error saving challenge: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan tantangan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C4B4),
        title: const Text('Tambah Tantangan'),
        leading: IconButton(
          icon: Image.network(
            'https://cdn-icons-png.freepik.com/256/10024/10024483.png?ga=GA1.1.1296858242.1742907295&semt=ais_hybrid',
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
                decoration: const InputDecoration(labelText: 'Nama Tantangan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tantangan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetController,
                decoration: const InputDecoration(labelText: 'Target (contoh: 5000 untuk 5K)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Target wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Target harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Durasi (contoh: 7 hari)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Durasi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChallenge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C4B4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Simpan Tantangan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
