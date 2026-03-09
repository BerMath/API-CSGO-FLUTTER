import 'package:flutter/material.dart';

class HighlightDetailScreen extends StatefulWidget {
  final dynamic highlight;

  const HighlightDetailScreen({super.key, required this.highlight});

  @override
  State<HighlightDetailScreen> createState() => _HighlightDetailScreenState();
}

class _HighlightDetailScreenState extends State<HighlightDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.highlight['image'] ?? widget.highlight['icon'] ?? '';
    final name = widget.highlight['name'] ?? 'Unknown';
    final rarity = widget.highlight['rarity']?['name'] ?? 'Unknown';
    final rarityColor = _getRarityColor(rarity);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Gloves Details'),
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
                          'GLOVES',
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

              // Collection
              if (widget.highlight['collection'] != null) ...[
                _buildDetailRow('Collection', widget.highlight['collection']['name']),
                const SizedBox(height: 16),
              ],

              // Type
              _buildDetailRow('Type', 'Gloves'),
              const SizedBox(height: 16),

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