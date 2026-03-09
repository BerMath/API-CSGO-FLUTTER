// lib/screens/skin_detail_screen.dart
import 'package:flutter/material.dart';


class SkinDetailScreen extends StatefulWidget {
  final dynamic skin;

  const SkinDetailScreen({super.key, required this.skin});

  @override
  State<SkinDetailScreen> createState() => _SkinDetailScreenState();
}

class _SkinDetailScreenState extends State<SkinDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.skin['image'] ?? widget.skin['icon'] ?? '';
    final name = widget.skin['name'] ?? 'Unknown';
    final weapon = widget.skin['weapon']?['title'] ?? 'Unknown Weapon';
    final rarity = widget.skin['rarity']?['name'] ?? 'Unknown';
    final rarityColor = _getRarityColor(rarity);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Skin Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image),
                      ),
              ),
              const SizedBox(height: 20),

              // Name and favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weapon,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Rarity badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: rarityColor.withOpacity(0.2),
                  border: Border.all(color: rarityColor),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  rarity,
                  style: TextStyle(
                    color: rarityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Market Value
              if (widget.skin['prices'] != null) ...[
                Text(
                  'MARKET VALUE',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.skin['prices']?['latest'] ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Wear condition
              if (widget.skin['wears'] != null) ...[
                Text(
                  'WEAR: ${widget.skin['wears']?[0]?['name'] ?? 'N/A'}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[900]!,
                        Colors.blue[700]!,
                        Colors.green[700]!,
                        Colors.yellow[700]!,
                        Colors.orange[700]!,
                        Colors.red[700]!,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FN',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'MW',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'FT',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'WW',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'BS',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Collection
              if (widget.skin['collection'] != null) ...[
                _buildDetailRow('Collection', widget.skin['collection']['name']),
                const SizedBox(height: 16),
              ],

              // Finish Style
              if (widget.skin['finish'] != null) ...[
                _buildDetailRow('Finish Style', widget.skin['finish']['name']),
                const SizedBox(height: 16),
              ],

              // Rarity full
              _buildDetailRow('Rarity', rarity),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'consumer grade':
        return Colors.blue;
      case 'industrial grade':
        return Colors.cyan;
      case 'mil-spec':
        return Colors.purple;
      case 'restricted':
        return Colors.deepPurple;
      case 'classified':
        return Colors.pink;
      case 'covert':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}