import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../pages/comments_page.dart';

class ReelItem extends StatefulWidget {
  final Map<String, dynamic> reelData;
  final int index;
  final bool isCurrentPage;
  final VoidCallback onLikeToggle;

  const ReelItem({
    Key? key,
    required this.reelData,
    required this.index,
    required this.isCurrentPage,
    required this.onLikeToggle,
  }) : super(key: key);

  @override
  _ReelItemState createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.reelData['videoUrl'])
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        if (widget.isCurrentPage) {
          _controller.play();
          _controller.setLooping(true);
          setState(() {
            _isPlaying = true;
          });
        }
      }).catchError((error) {
        print('Error initializing video: $error');
      });
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentPage && !oldWidget.isCurrentPage) {
      _controller.play();
      _controller.setLooping(true);
      setState(() {
        _isPlaying = true;
      });
    } else if (!widget.isCurrentPage && oldWidget.isCurrentPage) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          if (_isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                ),
                Text(
                  'Reels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
              ],
            ),
          ),
          if (!_isPlaying)
            Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white.withOpacity(0.7),
                size: 80,
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  NetworkImage(widget.reelData['userImage']),
                            ),
                            SizedBox(width: 10),
                            Text(
                              widget.reelData['userName'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.reelData['description'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: widget.reelData['isLiked']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: _formatNumber(widget.reelData['likes']),
                        color: widget.reelData['isLiked']
                            ? Colors.red
                            : Colors.white,
                        onTap: widget.onLikeToggle,
                      ),
                      SizedBox(height: 20),
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: _formatNumber(widget.reelData['comments']),
                        color: Colors.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsPage()),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      _buildActionButton(
                        icon: Icons.send_outlined,
                        label: _formatNumber(widget.reelData['shares']),
                        color: Colors.white,
                        onTap: () {},
                      ),
                      SizedBox(height: 20),
                      _buildActionButton(
                        icon: Icons.more_vert,
                        label: '',
                        color: Colors.white,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}