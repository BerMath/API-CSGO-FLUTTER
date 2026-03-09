import 'package:flutter/material.dart';
import '../services/csgo_api_service.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  final _api = CsgoApiService(language: 'fr');
  late Future<List<dynamic>> _highlightsFuture;

  @override
  void initState() {
    super.initState();
    _highlightsFuture = _api.getHighlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CS:GO Highlights')),
      body: FutureBuilder<List<dynamic>>(
        future: _highlightsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final highlights = snapshot.data!;
          return ListView.builder(
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              final highlight = highlights[index];
              return ListTile(
                title: Text(highlight['name'] ?? ''),
                subtitle: Text(highlight['rarity']?['name'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}