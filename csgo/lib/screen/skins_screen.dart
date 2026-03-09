import 'package:flutter/material.dart';
import '../services/csgo_api_service.dart';

class SkinsScreen extends StatefulWidget {
  const SkinsScreen({super.key});

  @override
  State<SkinsScreen> createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen> {
  final _api = CsgoApiService(language: 'fr');
  late Future<List<dynamic>> _skinsFuture;

  @override
  void initState() {
    super.initState();
    _skinsFuture = _api.getSkins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CS:GO Skins')),
      body: FutureBuilder<List<dynamic>>(
        future: _skinsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final skins = snapshot.data!;
          return ListView.builder(
            itemCount: skins.length,
            itemBuilder: (context, index) {
              final skin = skins[index];
              return ListTile(
                title: Text(skin['name'] ?? ''),
                subtitle: Text(skin['rarity']?['name'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}