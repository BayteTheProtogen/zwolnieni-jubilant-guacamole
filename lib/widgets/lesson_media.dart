import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class LessonMedia extends StatefulWidget {
  final String? imageUrl;
  final String? videoUrl;

  const LessonMedia({super.key, this.imageUrl, this.videoUrl});

  @override
  State<LessonMedia> createState() => _LessonMediaState();
}

class _LessonMediaState extends State<LessonMedia> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoController!),
                    IconButton(
                      icon: Icon(
                        _videoController!.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                        size: 50,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      onPressed: () {
                        setState(() {
                          _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
                        });
                      },
                    ),
                  ],
                ),
              )
            : const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      );
    }

    if (widget.imageUrl != null) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade100, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl!,
          placeholder: (context, url) => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
