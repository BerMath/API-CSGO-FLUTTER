import 'package:flutter/material.dart';
import 'screen/skins_screen.dart';
import 'screen/cases_screen.dart';
import 'screen/highlights_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS:GO Items',
      theme: ThemeData(
        // Thème sombre
        useMaterial3: true,
        brightness: Brightness.dark,
        
        // Couleur primaire (AppBar, buttons, etc)
        primaryColor: Colors.blue,
        
        // Couleur de fond des pages
        scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Bleu foncé
        
        // Couleur de l'AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F3460),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        
        // Couleur des cards
        cardTheme: CardThemeData(
          color: const Color(0xFF16213E),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        
        // Couleur du SearchBar
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStateProperty.all(
            const Color(0xFF16213E),
          ),
        ),
        
        // Couleur des icônes
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SkinsScreen(),
    const CasesScreen(),
    const HighlightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF0F3460),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Skins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Cases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Highlights',
          ),
        ],
      ),
    );
  }
}