import 'package:flutter/material.dart';
import '../widgets/reel_item.dart';

class ReelsPage extends StatefulWidget {
  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> reelsData = [
    {
      'userName': 'Lucas Mokmana',
      'userImage': 'https://randomuser.me/api/portraits/men/9.jpg',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'description': 'Amazing nature video 🌅',
      'likes': 12453,
      'comments': 324,
      'shares': 89,
      'isLiked': false,
    },
    {
      'userName': 'Emilia Rose',
      'userImage': 'https://randomuser.me/api/portraits/women/2.jpg',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'description': 'Beautiful moments 🎬 #creative',
      'likes': 8764,
      'comments': 201,
      'shares': 45,
      'isLiked': false,
    },
    {
      'userName': 'Richard Chen',
      'userImage': 'https://randomuser.me/api/portraits/men/3.jpg',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'description': 'Epic adventure ✨',
      'likes': 15234,
      'comments': 456,
      'shares': 123,
      'isLiked': false,
    },
    {
      'userName': 'Jasmine Park',
      'userImage': 'https://randomuser.me/api/portraits/women/4.jpg',
      'videoUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'description': 'Explore the world 🌍',
      'likes': 9876,
      'comments': 287,
      'shares': 67,
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reelsData.length,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return ReelItem(
            reelData: reelsData[index],
            index: index,
            isCurrentPage: currentPage == index,
            onLikeToggle: () {
              setState(() {
                reelsData[index]['isLiked'] = !reelsData[index]['isLiked'];
                reelsData[index]['isLiked']
                    ? reelsData[index]['likes']++
                    : reelsData[index]['likes']--;
              });
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}