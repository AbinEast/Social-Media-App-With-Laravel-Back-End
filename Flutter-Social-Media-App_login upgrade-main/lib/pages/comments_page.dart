import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final List<Map<String, dynamic>> comments = [
    {
      'name': 'Lucas Mokmana',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'comment':
          'Awesome app i ever used. great structure, and customizable for multipurpose. 😊😇',
      'likes': 3,
      'liked': false,
    },
    {
      'name': 'Lucas',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
      'comment': 'Yes I am also use this.🙂',
      'likes': 0,
      'liked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var c = comments[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(c['image'])),
                  title: Text(c['name'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['comment']),
                      Text('${c['likes']} Like  •  Reply  •  Send',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      c['liked'] ? Icons.favorite : Icons.favorite_border,
                      color: c['liked'] ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        c['liked'] = !c['liked'];
                        c['liked'] ? c['likes']++ : c['likes']--;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
