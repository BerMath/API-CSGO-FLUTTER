// lib/screens/skins_screen.dart
import 'package:flutter/material.dart';
import '../services/csgo_api_service.dart';
import 'skin_detail.dart';

class SkinsScreen extends StatefulWidget {
  const SkinsScreen({super.key});

  @override
  State<SkinsScreen> createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen> {
  final _api = CsgoApiService(language: 'en');
  late Future<List<dynamic>> _skinsFuture;
  final SearchController _searchController = SearchController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _skinsFuture = _api.getSkins();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterSkins(List<dynamic> skins) {
    if (_searchQuery.isEmpty) {
      return skins;
    }

    final query = _searchQuery.toLowerCase().trim();

    return skins.where((skin) {
      try {
        // Cherche dans le nom
        final name = (skin['name'] ?? '').toString().toLowerCase();
        if (name.contains(query)) return true;

        // Cherche dans la rareté
        final rarity = (skin['rarity']?['name'] ?? '').toString().toLowerCase();
        if (rarity.contains(query)) return true;

        // Cherche dans l'arme
        final weapon = (skin['weapon']?['title'] ?? '').toString().toLowerCase();
        if (weapon.contains(query)) return true;

        // Cherche dans la collection
        final collection = (skin['collection']?['name'] ?? '').toString().toLowerCase();
        if (collection.contains(query)) return true;

        return false;
      } catch (e) {
        print('Erreur filtrage: $e');
        return false;
      }
    }).toList();
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
          final filteredSkins = _filterSkins(skins);
        

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  controller: _searchController,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  leading: const Icon(Icons.search),
                  hintText: 'Chercher un skin (AK-47, Dragon, etc)...',
                ),
              ),

              // Results count
              if (_searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${filteredSkins.length} résultats',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),

              // Grid View
              Expanded(
                child: filteredSkins.isEmpty && _searchQuery.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun skin trouvé',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: filteredSkins.length,
                        itemBuilder: (context, index) {
                          final skin = filteredSkins[index];
                          final imageUrl = skin['image'] ?? skin['icon'] ?? '';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SkinDetailScreen(skin: skin),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  // Image
                                  Expanded(
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                    Icons.image_not_supported),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image),
                                          ),
                                  ),
                                  // Info
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          skin['name'] ?? 'N/A',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          skin['rarity']?['name'] ??
                                              'Unknown',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}