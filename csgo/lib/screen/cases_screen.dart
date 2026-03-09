import 'package:flutter/material.dart';
import '../services/csgo_api_service.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  final _api = CsgoApiService(language: 'fr');
  late Future<List<dynamic>> _casesFuture;

  @override
  void initState() {
    super.initState();
    _casesFuture = _api.getCases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CS:GO Cases')),
      body: FutureBuilder<List<dynamic>>(
        future: _casesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final cases = snapshot.data!;
          return ListView.builder(
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final caseItem = cases[index];
              return ListTile(
                title: Text(caseItem['name'] ?? ''),
                subtitle: Text(caseItem['collection']?['name'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}