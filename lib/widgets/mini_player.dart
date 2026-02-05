import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider package
import '../providers/player_provider.dart';
import '../screens/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, provider, child) {
        if (provider.currentLesson == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            // Navigate to full player with current playlist
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerScreen(
                  lessons: [provider.currentLesson!], // Or full list if available
                  initialIndex: 0,
                ),
              ),
            );
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: const AssetImage('assets/images/bin_umar.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.currentLesson!.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          provider.isPlaying ? 'Playing' : 'Paused',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(provider.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      provider.isPlaying ? provider.pause() : provider.resume();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: provider.playNext,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}