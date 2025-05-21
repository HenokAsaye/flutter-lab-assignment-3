import 'package:flutter/material.dart';
import '../../data/models/album.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                color: Colors.black26,
                child: Text(
                  'Album #${album.albumId}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: Hero(
                tag: 'album_${album.id}',
                child: Image.network(
                  album.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    context,
                    title: 'Title',
                    content: album.title,
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    title: 'Album Information',
                    content: 'Album ID: ${album.albumId}\nPhoto ID: ${album.id}',
                    icon: Icons.info_outline,
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    title: 'URLs',
                    content: 'Original: ${album.url}\nThumbnail: ${album.thumbnailUrl}',
                    icon: Icons.link,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your share functionality here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Share functionality coming soon!')),
          );
        },
        child: const Icon(Icons.share),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
} 