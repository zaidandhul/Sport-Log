import 'dart:io' show Platform; // Untuk deteksi platform
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/splash_screen.dart';
import 'screens/main_menu.dart';
import 'screens/add_activity.dart';
import 'screens/edit_activity.dart';
import 'screens/add_community.dart';
import 'screens/add_challenge.dart';
import 'services/database_helper.dart';
import 'models/activity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi sqflite_ffi untuk desktop
  if (_isDesktop()) {
    databaseFactory = databaseFactoryFfi;
  }

  debugPrint('Starting SportLog application...');

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final dbHelper = DatabaseHelper.instance;
        dbHelper.database.then((_) => debugPrint('Database initialized successfully'));
        return dbHelper;
      },
      child: const MyApp(),
    ),
  );
}

// Fungsi untuk mendeteksi platform desktop
bool _isDesktop() {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Provider.of<DatabaseHelper>(context, listen: false).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportLog',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFE5E7EB),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF10B981), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          suffixIconColor: Color(0xFF10B981),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            elevation: WidgetStatePropertyAll(8),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF10B981),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          unselectedLabelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainMenu(),
        '/add': (context) => const AddActivity(),
        '/edit': (context) {
          final activity = ModalRoute.of(context)?.settings.arguments as Activity?;
          if (activity == null) {
            return const Scaffold(
              body: Center(child: Text('Aktivitas tidak ditemukan')),
            );
          }
          return EditActivity(activity: activity);
        },
        '/add_community': (context) => const AddCommunity(),
        '/add_challenge': (context) => const AddChallenge(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rute tidak ditemukan')),
          ),
        );
      },
    );
  }
}