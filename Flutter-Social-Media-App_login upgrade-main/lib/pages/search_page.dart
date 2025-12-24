import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> galleryImages = [
    'https://picsum.photos/400/600?random=20',
    'https://picsum.photos/400/300?random=21',
    'https://picsum.photos/400/600?random=22',
    'https://picsum.photos/400/400?random=23',
    'https://picsum.photos/400/500?random=24',
    'https://picsum.photos/400/600?random=25',
    'https://picsum.photos/400/400?random=26',
    'https://picsum.photos/400/300?random=27',
    'https://picsum.photos/400/600?random=28',
    'https://picsum.photos/400/500?random=29',
    'https://picsum.photos/400/600?random=30',
    'https://picsum.photos/400/400?random=31',
    'https://picsum.photos/400/600?random=32',
    'https://picsum.photos/400/300?random=33',
    'https://picsum.photos/400/500?random=34',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            title: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search..',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(4),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Bisa tambahkan detail view di sini
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        galleryImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                childCount: galleryImages.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}