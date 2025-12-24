import 'package:flutter/material.dart';

class FollowListPage extends StatefulWidget {
  final String type; // 'followers' atau 'following'

  const FollowListPage({Key? key, required this.type}) : super(key: key);

  @override
  _FollowListPageState createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  bool _isGridView = false;

  // Daftar teman dengan status follow/unfollow
  final List<Map<String, dynamic>> friends = [
    {'name': 'Andy Lee', 'image': 'https://randomuser.me/api/portraits/women/68.jpg', 'isFollowing': true},
    {'name': 'Brian Harahap', 'image': 'https://randomuser.me/api/portraits/women/21.jpg', 'isFollowing': true},
    {'name': 'Christian Hang', 'image': 'https://randomuser.me/api/portraits/men/35.jpg', 'isFollowing': true},
    {'name': 'Chloe Mc.Jenskin', 'image': 'https://randomuser.me/api/portraits/women/54.jpg', 'isFollowing': true},
    {'name': 'David Bekam', 'image': 'https://randomuser.me/api/portraits/men/48.jpg', 'isFollowing': true},
    {'name': 'Dons John', 'image': 'https://randomuser.me/api/portraits/women/33.jpg', 'isFollowing': true},
    {'name': 'Eric Leew', 'image': 'https://randomuser.me/api/portraits/men/23.jpg', 'isFollowing': true},
    {'name': 'Richard Sigh', 'image': 'https://randomuser.me/api/portraits/men/30.jpg', 'isFollowing': true},
  ];

  @override
  Widget build(BuildContext context) {
    final isFollowers = widget.type == 'followers';
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
        'Jovi Daniel Jr',
        style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
         ),
        ),
       ),
      ),
      body: Column(
        children: [
          // Tabs Followers / Following
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isFollowers) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FollowListPage(type: 'followers')),
                      );
                    }
                  },
                  child: Text(
                    '245 Followers',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // ukuran responsif
                      fontWeight: FontWeight.bold,
                      color: isFollowers ? Colors.orange : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    if (isFollowers) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FollowListPage(type: 'following')),
                      );
                    }
                  },
                  child: Text(
                    '85 Following',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: !isFollowers ? Colors.orange : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Header + tombol layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Friends',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.grid_view_rounded,
                          color: _isGridView ? Colors.orange : Colors.grey),
                      onPressed: () => setState(() => _isGridView = true),
                    ),
                    IconButton(
                      icon: Icon(Icons.list,
                          color: !_isGridView ? Colors.orange : Colors.grey),
                      onPressed: () => setState(() => _isGridView = false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _isGridView
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2.4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(friend['image']),
                                radius: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(friend['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 6),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    friend['isFollowing'] = !friend['isFollowing'];
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: friend['isFollowing']
                                          ? Colors.orange
                                          : Colors.grey),
                                  foregroundColor: friend['isFollowing']
                                      ? Colors.orange
                                      : Colors.grey,
                                  minimumSize: const Size(90, 28),
                                ),
                                child: Text(
                                  friend['isFollowing'] ? "UNFOLLOW" : "FOLLOW",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(friend['image']),
                            radius: 25,
                          ),
                          title: Text(friend['name']),
                          trailing: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                friend['isFollowing'] = !friend['isFollowing'];
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: friend['isFollowing']
                                      ? Colors.orange
                                      : Colors.grey),
                              foregroundColor: friend['isFollowing']
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            child: Text(
                                friend['isFollowing'] ? "UNFOLLOW" : "FOLLOW"),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
