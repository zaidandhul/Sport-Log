import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportlog/screens/splash_screen.dart';
import 'package:sportlog/screens/main_menu.dart';
import 'package:sportlog/screens/edit_activity.dart';
import 'package:sportlog/screens/add_community.dart';
import 'package:sportlog/screens/add_challenge.dart';
import 'package:sportlog/models/activity.dart';
import 'package:provider/provider.dart';
import 'package:sportlog/services/database_helper.dart';
import 'package:sportlog/models/community.dart';
import 'package:sportlog/models/health_tip.dart';
import 'package:sportlog/models/challenge.dart';

void main() {
  setUp(() async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database.then((db) async {
      await db.delete('activities');
      await db.delete('communities');
      await db.delete('health_tips');
      await db.delete('challenges');
    });
  });

  group('SplashScreen Tests', () {
    testWidgets('SplashScreen displays title, slogan, and Let\'s Go button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('SportLog'), findsOneWidget);
      expect(find.text('Log Your Active Life!'), findsOneWidget);
      expect(find.text('Let\'s Go'), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);
    });

    testWidgets('Let\'s Go button navigates to main route', (WidgetTester tester) async {
      final routes = {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainMenu(),
        '/add': (context) => const Scaffold(body: Text('AddActivity')),
      };
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: routes,
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.text('Let\'s Go'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('SportLog'), findsOneWidget);
    });
  });

  group('MainMenu Tests', () {
    testWidgets('Navigate to AddCommunity from Community tab and add community', (WidgetTester tester) async {
      final dbHelper = DatabaseHelper.instance;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => dbHelper,
          child: MaterialApp(
            initialRoute: '/main',
            routes: {
              '/main': (context) => const MainMenu(),
              '/add_community': (context) => const AddCommunity(),
            },
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.text('Komunitas'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Tambah Komunitas'), findsOneWidget);

      // Tambah komunitas
      await tester.enterText(find.byType(TextFormField).at(0), 'Komunitas Lari Jakarta');
      await tester.enterText(find.byType(TextFormField).at(1), 'Lari');
      await tester.enterText(find.byType(TextFormField).at(2), 'Jakarta Pusat');
      await tester.enterText(find.byType(TextFormField).at(3), 'Minggu, 06:00');
      await tester.tap(find.text('Simpan Komunitas'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Komunitas berhasil ditambahkan'), findsOneWidget);

      // Verifikasi di tab Komunitas
      final communities = await dbHelper.getCommunities();
      expect(communities.any((c) => c.name == 'Komunitas Lari Jakarta'), isTrue);
    });

    testWidgets('Navigate to AddChallenge from Challenge tab and add challenge', (WidgetTester tester) async {
      final dbHelper = DatabaseHelper.instance;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => dbHelper,
          child: MaterialApp(
            initialRoute: '/main',
            routes: {
              '/main': (context) => const MainMenu(),
              '/add_challenge': (context) => const AddChallenge(),
            },
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.text('Tantangan'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Tambah Tantangan'), findsOneWidget);

      // Tambah tantangan
      await tester.enterText(find.byType(TextFormField).at(0), 'Tantangan Lari 10K');
      await tester.enterText(find.byType(TextFormField).at(1), 'Lari 10K dalam 2 minggu');
      await tester.enterText(find.byType(TextFormField).at(2), '10000');
      await tester.enterText(find.byType(TextFormField).at(3), '14 hari');
      await tester.tap(find.text('Simpan Tantangan'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Tantangan berhasil ditambahkan'), findsOneWidget);

      // Verifikasi di tab Tantangan
      final challenges = await dbHelper.getChallenges();
      expect(challenges.any((c) => c.name == 'Tantangan Lari 10K'), isTrue);
    });

    testWidgets('Tabs display correct content', (WidgetTester tester) async {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertActivity(Activity(
        id: 1,
        type: 'Lari',
        duration: 30,
        date: DateTime.now().toIso8601String(),
      ));
      await dbHelper.insertCommunity(Community(
        id: 1,
        name: 'Lari Komunitas',
        sportType: 'Lari',
        location: 'Jakarta',
        schedule: 'Sabtu, 07:00',
      ));
      await dbHelper.insertHealthTip(HealthTip(
        id: 1,
        sportType: 'Lari',
        tip: 'Jaga hidrasi saat lari.',
      ));
      await dbHelper.insertChallenge(Challenge(
        id: 1,
        name: 'Lari 5K',
        description: 'Selesaikan 5K dalam seminggu.',
        target: 5000,
        duration: '7 hari',
      ));

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => dbHelper,
          child: const MaterialApp(
            home: MainMenu(),
          ),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Tab Aktivitas
      expect(find.text('Aktivitas'), findsOneWidget);
      expect(find.text('Lari'), findsOneWidget);

      // Tab Komunitas
      await tester.tap(find.text('Komunitas'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Komunitas'), findsOneWidget);
      expect(find.text('Lari Komunitas'), findsOneWidget);

      // Tab Tips Kesehatan
      await tester.tap(find.text('Tips Kesehatan'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Tips Kesehatan'), findsOneWidget);
      expect(find.text('Jaga hidrasi saat lari.'), findsOneWidget);

      // Tab Tantangan
      await tester.tap(find.text('Tantangan'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Tantangan'), findsOneWidget);
      expect(find.text('Lari 5K'), findsOneWidget);
    });
  });
}