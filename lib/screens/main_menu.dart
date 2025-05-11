import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_helper.dart';
import '../models/activity.dart';
import '../models/community.dart';
import '../models/health_tip.dart';
import '../models/challenge.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Untuk memicu rebuild FAB saat tab berubah
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Widget> _loadNetworkIcon(String url) async {
    try {
      return Image.network(
        url,
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.add);
        },
      );
    } catch (e) {
      return const Icon(Icons.add);
    }
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

  void _refreshHealthTips() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF10B981),
        title: const Text('SportLog'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aktivitas'),
            Tab(text: 'Komunitas'),
            Tab(text: 'Tips Kesehatan'),
            Tab(text: 'Tantangan'),
          ],
        ),
        actions: [
          if (_tabController.index == 2) // Hanya untuk Tips Kesehatan
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshHealthTips,
              tooltip: 'Refresh Tips',
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab Aktivitas
          Consumer<DatabaseHelper>(
            builder: (context, dbHelper, child) {
              return FutureBuilder<List<Activity>>(
                future: dbHelper.getActivities(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final activities = snapshot.data!;
                  if (activities.isEmpty) {
                    return const Center(child: Text('Belum ada aktivitas'));
                  }
                  return ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final kalori = _hitungKalori(activity.type, activity.duration);
                      return ListTile(
                        title: Text(activity.type),
                        subtitle: Text(
                          'Durasi: ${activity.duration} menit - ${activity.date}\n'
                              'Kalori terbakar: ${kalori.toStringAsFixed(2)} kalori',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit', arguments: activity);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await dbHelper.deleteActivity(activity.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Aktivitas dihapus'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        dbHelper.insertActivity(activity);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          // Tab Komunitas
          Consumer<DatabaseHelper>(
            builder: (context, dbHelper, child) {
              return FutureBuilder<List<Community>>(
                future: dbHelper.getCommunities(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final communities = snapshot.data!;
                  if (communities.isEmpty) {
                    return const Center(child: Text('Belum ada komunitas'));
                  }
                  return ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      final community = communities[index];
                      return ListTile(
                        title: Text(community.name),
                        subtitle: Text(
                            'Olahraga: ${community.sportType}\nLokasi: ${community.location}\nJadwal: ${community.schedule}'),
                      );
                    },
                  );
                },
              );
            },
          ),
          // Tab Tips Kesehatan
          Consumer<DatabaseHelper>(
            builder: (context, dbHelper, child) {
              return FutureBuilder<List<HealthTip>>(
                future: dbHelper.getHealthTips(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final healthTips = snapshot.data!;
                  if (healthTips.isEmpty) {
                    return const Center(child: Text('Belum ada tips kesehatan'));
                  }
                  debugPrint('Health tips count: ${healthTips.length}'); // Tambahkan log untuk debugging
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: healthTips.length,
                    itemBuilder: (context, index) {
                      final tip = healthTips[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            tip.sportType,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(tip.tip),
                          contentPadding: const EdgeInsets.all(16.0),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          // Tab Tantangan
          Consumer<DatabaseHelper>(
            builder: (context, dbHelper, child) {
              return FutureBuilder<List<Challenge>>(
                future: dbHelper.getChallenges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final challenges = snapshot.data!;
                  if (challenges.isEmpty) {
                    return const Center(child: Text('Belum ada tantangan'));
                  }
                  return ListView.builder(
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      final challenge = challenges[index];
                      return ListTile(
                        title: Text(challenge.name),
                        subtitle: Text(
                            'Deskripsi: ${challenge.description}\nTarget: ${challenge.target}\nDurasi: ${challenge.duration}'),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) {
          switch (_tabController.index) {
            case 0:
              return FutureBuilder<Widget>(
                future: _loadNetworkIcon('https://cdn-icons-png.freepik.com/256/14034/14034302.png?ga=GA1.1.1296858242.1742907295&semt=ais_hybrid'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const FloatingActionButton(
                      onPressed: null,
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add');
                    },
                    child: snapshot.data!,
                    tooltip: 'Tambah Aktivitas',
                  );
                },
              );
            case 1:
              return FutureBuilder<Widget>(
                future: _loadNetworkIcon('https://cdn-icons-png.freepik.com/256/6318/6318490.png?ga=GA1.1.1296858242.1742907295&semt=ais_hybrid'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const FloatingActionButton(
                      onPressed: null,
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_community');
                    },
                    child: snapshot.data!,
                    tooltip: 'Tambah Komunitas',
                  );
                },
              );
            case 3:
              return FutureBuilder<Widget>(
                future: _loadNetworkIcon('https://cdn-icons-png.freepik.com/256/16597/16597161.png?ga=GA1.1.1296858242.1742907295&semt=ais_hybrid'),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const FloatingActionButton(
                      onPressed: null,
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_challenge');
                    },
                    child: snapshot.data!,
                    tooltip: 'Tambah Tantangan',
                  );
                },
              );
            default:
              return const SizedBox.shrink(); // No FAB for Tips Kesehatan
          }
        },
      ),
    );
  }
}