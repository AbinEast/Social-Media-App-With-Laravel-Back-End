import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notificationsToday = [
    {
      'time': '5h ago',
      'image': 'https://picsum.photos/200/200?random=10',
      'text': '@davidjr mention you in a comment: @joviedan Lol',
      'desc': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do"',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.purple,
    },
    {
      'time': '6h ago',
      'image': 'https://picsum.photos/200/200?random=11',
      'text': '@henry and 5 others liked your post',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    {
      'time': '5h ago',
      'image': 'https://picsum.photos/200/200?random=12',
      'text': '@emilia and 2 others liked your post',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> notificationsThisYear = [
    {
      'time': '5h ago',
      'image': 'https://picsum.photos/200/200?random=13',
      'text': '@davidjr mention you in a comment: @joviedan Lol',
      'desc': '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do"',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.purple,
    },
    {
      'time': '5h ago',
      'image': 'https://picsum.photos/200/200?random=14',
      'text': '@lucas mention you in a story',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.purple,
    },
    {
      'time': '6h ago',
      'image': 'https://picsum.photos/200/200?random=15',
      'text': '@henry and 5 others liked your post',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Text("Today",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...notificationsToday.map((n) => _notifTile(n)).toList(),
          SizedBox(height: 20),
          Text("This year",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...notificationsThisYear.map((n) => _notifTile(n)).toList(),
        ],
      ),
    );
  }

  Widget _notifTile(Map<String, dynamic> n) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(n['image'], width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(n['time'], style: TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 2),
          Text(
            n['text'],
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          ),
          if (n.containsKey('desc'))
            Text(
              n['desc'],
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      trailing: CircleAvatar(
        radius: 15,
        backgroundColor: n['color'],
        child: Icon(n['icon'], color: Colors.white, size: 16),
      ),
    );
  }
}