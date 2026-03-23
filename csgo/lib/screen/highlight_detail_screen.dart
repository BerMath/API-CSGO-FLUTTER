import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HighlightDetailScreen extends StatefulWidget {
  final Map<String, dynamic> highlight;

  const HighlightDetailScreen({super.key, required this.highlight});

  @override
  State<HighlightDetailScreen> createState() => _HighlightDetailScreenState();
}

class _HighlightDetailScreenState extends State<HighlightDetailScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _initializeVideo() {
    final videoUrl = widget.highlight['video']?.toString().trim() ?? '';

    if (videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune URL vidéo disponible')),
      );
      return;
    }

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    );

    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            chewieController: _chewieController!,
          ),
        ),
      ).then((_) {
        _videoPlayerController?.dispose();
        _chewieController?.dispose();
        _videoPlayerController = null;
        _chewieController = null;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    });
  }

  String get playerName => widget.highlight['tournament_player'] ?? 'Inconnu';
  String get shortName => (widget.highlight['name'] ?? '').toString().split(' | ').last.trim();
  String get tournamentName => widget.highlight['tournament_name'] ?? '';
  String get imageUrl => widget.highlight['thumbnail'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playerName),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 220,
                color: Colors.blueGrey[800],
              ),
            // Bouton Lire la vidéo
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _initializeVideo,
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Lire la vidéo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(
                    icon: Icons.person,
                    label: 'Joueur',
                    value: playerName,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.star,
                    label: 'Highlight',
                    value: shortName,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  if (tournamentName.isNotEmpty)
                    _InfoCard(
                      icon: Icons.emoji_events,
                      label: 'Tournoi',
                      value: tournamentName,
                      color: Colors.green,
                    ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.info,
                    label: 'Description',
                    value: widget.highlight['description'] ?? '',
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    label: 'Team',
                    value: widget.highlight['team0'] ?? '',
                    color: Colors.blueAccent,
                    icon: Icons.info,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    label: 'Team',
                    value: widget.highlight['team1'] ?? '',
                    color: Colors.orangeAccent,
                    icon: Icons.info,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ChewieController chewieController;

  const VideoPlayerScreen({
    super.key,
    required this.chewieController,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecteur vidéo'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Chewie(
          controller: widget.chewieController,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}