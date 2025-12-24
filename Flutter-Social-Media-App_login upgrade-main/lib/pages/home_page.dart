import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:responsi/pages/sign_in_screen.dart';
import 'package:responsi/pages/welcome_page.dart';
import 'search_page.dart';
import 'story_view_page.dart';
import 'reels_page.dart';
import 'notifications_page.dart';
import 'comments_page.dart';
import 'create_post_page.dart';
import 'chat_list_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Variabel UI
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  Color _primaryColor = Colors.orange;

  // Variabel Data
  String _userName = "User";
  int? _currentUserId; // Tambahan: ID User yang sedang login
  List<dynamic> _posts = []; 
  bool _isLoadingPosts = true;

  // Data Story (Statis)
  final List<Map<String, String>> stories = [
    {'name': 'Your Story', 'image': 'https://randomuser.me/api/portraits/men/1.jpg'},
    {'name': 'Emilia', 'image': 'https://randomuser.me/api/portraits/women/2.jpg'},
    {'name': 'Richard', 'image': 'https://randomuser.me/api/portraits/men/3.jpg'},
    {'name': 'Jasmine', 'image': 'https://randomuser.me/api/portraits/women/4.jpg'},
  ];

  final List<Color> _themeColors = [
    Colors.orange, Colors.blue, Colors.purple, Colors.green, Colors.pink, Colors.teal,
  ];

  Color get _backgroundColor => _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
  Color get _cardColor => _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white;
  Color get _textColor => _isDarkMode ? Colors.white : Colors.black;
  Color get _subtitleColor => _isDarkMode ? Colors.grey[400]! : Colors.grey;
  Color get _appBarColor => _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white;

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Ganti nama fungsi load agar sekalian ambil ID
    _fetchPosts();
  }

  // --- 1. Load Info User (Nama & ID) ---
  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Ambil detail user dari API untuk mendapatkan ID yang valid
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/user'), // Sesuaikan IP
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _currentUserId = data['id']; // Simpan ID User
            _userName = data['name'];
          });
          // Simpan juga ke prefs biar sinkron
          prefs.setString('name', data['name']);
          prefs.setString('email', data['email']);
        }
      } catch (e) {
        print("Error fetching user info: $e");
      }
    }
  }

  // --- Fetch Post ---
  Future<void> _fetchPosts() async {
    // Mengambil Token dari Penyimpanan Lokal
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // URL API (Mengarah ke IP Server)
    const String apiUrl = 'http://10.0.2.2:8000/api/posts'; 

    try {
      // Mengirim Request GET dengan Header Autentikasi
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      // Validasi Respon & Parsing Data
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Menyimpan data array dari key 'data' ke variabel list
          _posts = data['data']; 
          _isLoadingPosts = false;
        });
      } else {
        setState(() { _isLoadingPosts = false; });
      }
    } catch (e) {
      setState(() { _isLoadingPosts = false; });
    }
  }

  // --- Fungsi Delete Post ---
  Future<void> _deletePost(int postId) async {
    // Tampilkan konfirmasi dialog dulu
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Postingan"),
        content: const Text("Apakah Anda yakin ingin menghapus postingan ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // IP
    final String apiUrl = 'http://10.0.2.2:8000/api/posts/$postId';

    try {
      // Request DELETE ke API
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Hapus dari list lokal biar langsung hilang tanpa refresh
        setState(() {
          _posts.removeWhere((post) => post['id'] == postId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Postingan berhasil dihapus"), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus postingan"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // --- 4. Logout ---
  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); 
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8A5B)),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0: return _buildHomePage();
      case 1: return SearchPage();
      case 2: return ChatListPage();
      case 3: return ProfilePage();
      default: return _buildHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _backgroundColor,
      body: _getSelectedPage(),
      endDrawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );
          if (result == true) {
            _fetchPosts();
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: _appBarColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: _selectedIndex == 0 ? _primaryColor : _subtitleColor),
                onPressed: () {
                  setState(() => _selectedIndex = 0);
                  _loadUserInfo();
                  _fetchPosts();
                },
              ),
              IconButton(icon: Icon(Icons.search, color: _selectedIndex == 1 ? _primaryColor : _subtitleColor), onPressed: () => setState(() => _selectedIndex = 1)),
              const SizedBox(width: 40),
              IconButton(icon: Icon(Icons.chat_bubble_outline, color: _selectedIndex == 2 ? _primaryColor : _subtitleColor), onPressed: () => setState(() => _selectedIndex = 2)),
              IconButton(icon: Icon(Icons.person_outline, color: _selectedIndex == 3 ? _primaryColor : _subtitleColor), onPressed: () => setState(() => _selectedIndex = 3)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomePage() {
    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Text("Hi, $_userName!", style: TextStyle(color: _textColor, fontWeight: FontWeight.bold, fontSize: 22)),
            backgroundColor: _appBarColor,
            elevation: 0,
            floating: true,
            pinned: false,
            actions: [
              IconButton(icon: Icon(Icons.notifications_none, color: _primaryColor), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage())); }),
              IconButton(icon: Icon(Icons.video_collection_outlined, color: _primaryColor), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ReelsPage())); }),
              IconButton(icon: Icon(Icons.grid_view, color: _primaryColor), onPressed: () { _scaffoldKey.currentState?.openEndDrawer(); }),
              const SizedBox(width: 10),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStoriesSection(),

                // 1. Loading Indicator
                if (_isLoadingPosts)
                   Padding(padding: const EdgeInsets.all(20), child: CircularProgressIndicator(color: _primaryColor)),

                // 2. Postingan Dinamis (Database)
                if (!_isLoadingPosts && _posts.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      final user = post['user'];
                      
                      String imageUrl = "";
                      if (post['image'] != null) {
                        imageUrl = "http://10.0.2.2:8000/storage/" + post['image'];
                      }
                      
                      // Cek apakah ini post milik user yang login
                      // Kita bandingkan ID user login dengan ID user pembuat post
                      bool isOwner = false;
                      if (_currentUserId != null && post['user_id'] == _currentUserId) {
                        isOwner = true;
                      }

                      return _buildPostCard(
                        postId: post['id'], // Kirim ID post untuk delete
                        isOwner: isOwner,   // Kirim status kepemilikan
                        userName: user != null ? user['name'] : 'Unknown',
                        location: 'Posted from App',
                        timeAgo: 'Just now',
                        text: post['caption'] ?? "",
                        imageUrl: imageUrl,
                        likes: post['likes'] ?? 0,
                        comments: (post['comments'] ?? 0).toString(),
                      );
                    },
                  ),

                // 3. Postingan Statis (Bawaan)
                _buildPostCard(
                  userName: 'Lucas Mokmana',
                  location: 'Bangkok, Thailand',
                  timeAgo: '2m ago',
                  text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do sum sit emat 😎😎',
                  imageUrl: 'https://picsum.photos/400/600?random=1',
                  likes: 221,
                  comments: '150',
                ),
                _buildPostCard(
                  userName: 'Hendri Lee',
                  location: 'Shibuya, Japan',
                  timeAgo: '2m ago',
                  text: 'Menikmati sore hari di kota Tokyo ✨',
                  imageUrl: 'https://picsum.photos/400/600?random=2',
                  likes: 178,
                  comments: '80',
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StoryViewPage(stories: stories, initialIndex: index)));
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(radius: 30, backgroundImage: NetworkImage(stories[index]['image']!)),
                      if (index == 1)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                            child: const Text('Live', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(stories[index]['name']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Widget Post Card yang Diupdate ---
  Widget _buildPostCard({
    int? postId,       // ID Post (opsional karena post statis tidak punya ID DB)
    bool isOwner = false, // Apakah ini post milik user login?
    required String userName,
    required String location,
    required String timeAgo,
    required String text,
    required String imageUrl,
    required int likes,
    required String comments,
  }) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: _isDarkMode ? [] : [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://media.istockphoto.com/id/1495088043/vector/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=612x612&w=0&k=20&c=dhV2p1JwmloBTOaGAtaA3AW1KSnjsdMt7-U_3EZElZ0=')),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _textColor)),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: _subtitleColor),
                      Text('$location • $timeAgo', style: TextStyle(color: _subtitleColor, fontSize: 12)),
                    ],
                  )
                ],
              ),
              const Spacer(),
              
              // --- TOMBOL DELETE ATAU SHARE ---
              // Jika ini pemilik post, tampilkan tombol Hapus. Jika bukan, tampilkan Share.
              if (isOwner && postId != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deletePost(postId); // Panggil fungsi delete
                  },
                )
              else
                GestureDetector(
                  onTap: () => _showShareBottomSheet(context),
                  child: Icon(Icons.share, color: _primaryColor),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (text.isNotEmpty) Text(text, style: TextStyle(fontSize: 13, color: _textColor)),
          const SizedBox(height: 10),
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                errorBuilder: (context, error, stackTrace) => Container(height: 200, color: Colors.grey[200], child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey))),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.favorite_border, color: _subtitleColor),
              const SizedBox(width: 5),
              Text(likes.toString(), style: TextStyle(color: _textColor)),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage())); },
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, color: Colors.purple),
                    const SizedBox(width: 5),
                    Text(comments, style: TextStyle(color: _textColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 280,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(25))),
      child: Container(
        color: const Color(0xFFFFA36C),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: const EdgeInsets.only(bottom: 0),
              decoration: const BoxDecoration(color: Color(0xFFFFA36C)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://media.istockphoto.com/id/1495088043/vector/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=612x612&w=0&k=20&c=dhV2p1JwmloBTOaGAtaA3AW1KSnjsdMt7-U_3EZElZ0=')),
                  const SizedBox(height: 10),
                  const Text("Good Morning", style: TextStyle(color: Colors.white70)),
                  Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("MAIN MENU", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  _drawerItem(Icons.favorite, "Welcome", onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage())); }),
                  _drawerItem(Icons.home, "Home", onTap: () { Navigator.pop(context); setState(() => _selectedIndex = 0); _fetchPosts(); }),
                  _drawerItem(Icons.person_outline, "Profile", onTap: () { Navigator.pop(context); setState(() => _selectedIndex = 3); }),
                  _drawerItem(Icons.logout, "Logout", onTap: () { Navigator.pop(context); _handleLogout(); }),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 10),
                  const Text("SETTINGS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  _drawerItem(Icons.color_lens_outlined, "Color Theme", onTap: () { Navigator.pop(context); _showColorThemePicker(); }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {int? badge, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: badge != null ? Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10))) : null,
      onTap: onTap,
    );
  }

  void _showColorThemePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Choose Color Theme', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: _themeColors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () { setState(() => _primaryColor = _themeColors[index]); Navigator.pop(context); },
                  child: Container(
                    decoration: BoxDecoration(color: _themeColors[index], shape: BoxShape.circle, border: Border.all(color: _primaryColor == _themeColors[index] ? _textColor : Colors.transparent, width: 3)),
                    child: _primaryColor == _themeColors[index] ? const Icon(Icons.check, color: Colors.white, size: 30) : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showShareBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(height: 200, color: Colors.white, child: const Center(child: Text("Share menu placeholder"))),
    );
  }
}