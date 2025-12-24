import 'package:flutter/material.dart';
import 'package:responsi/pages/notifications_page.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Lucas Mokmana',
      'message': "Hey bro, let's meetup at centre point corner",
      'time': '2m ago',
      'image': 'https://randomuser.me/api/portraits/men/32.jpg',
      'isOnline': true,
      'isRead': false,
    },
    {
      'name': 'Emilia Green',
      'message': 'Can you share your current location now sis',
      'time': '2m ago',
      'image': 'https://randomuser.me/api/portraits/women/44.jpg',
      'isOnline': true,
      'isRead': true,
    },
    {
      'name': 'Richard lee',
      'message': "Cmon dude! make it fast, let's go",
      'time': '2m ago',
      'image': 'https://randomuser.me/api/portraits/men/46.jpg',
      'isOnline': true,
      'isRead': true,
    },
    {
      'name': 'Hendri Lee',
      'message': 'Did you tell him about your new car?',
      'time': '2m ago',
      'image': 'https://randomuser.me/api/portraits/women/47.jpg',
      'isOnline': true,
      'isRead': false,
    },
    {
      'name': 'Mogan Fox',
      'message': "Let's go!",
      'time': '2m ago',
      'image': 'https://randomuser.me/api/portraits/women/50.jpg',
      'isOnline': true,
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          floating: true,
          pinned: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Chat',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_none, color: Colors.orange, size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>NotificationsPage()),
                    );
                  },
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search..',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.orange),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Chat List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildChatItem(chats[index]);
            },
            childCount: chats.length,
          ),
        ),
      ],
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(chat['image']),
            ),
            if (chat['isOnline'])
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          chat['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          chat['message'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chat['time'],
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: chat['isRead'] ? Colors.grey[300] : Color(0xFF6C5CE7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(
                name: chat['name'],
                image: chat['image'],
                isOnline: chat['isOnline'],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}