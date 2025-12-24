import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  
  // Variabel Data User
  String _userName = "Loading..."; 

  // Variabel Logic Upload
  File? _imageFile;
  bool _isLoading = false;

  // Variabel UI Dropdown (Kosmetik)
  String _selectedPrivacy = 'Friends';
  String _selectedAlbum = 'Album';
  bool _isLocationOn = true;

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Ambil nama saat halaman dibuka
  }

  // 1. Fungsi Load Nama User
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? "User";
    });
  }

  // 2. Fungsi Submit Post ke Laravel
  Future<void> _submitPost() async {
    if (_postController.text.isEmpty && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi caption atau pilih foto dulu!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    
    // Ip backend
    const String apiUrl = 'http://10.0.2.2:8000/api/posts';

    try {
      // Setup Request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      // Menambahkan Header Token
      request.headers['Authorization'] = 'Bearer $token';
      // Menambahkan Data Teks (Body)
      request.fields['caption'] = _postController.text;
      // Menambahkan Data File (Gambar) jika ada
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      // Eksekusi Pengiriman
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Kembali ke Home & Refresh
        }
      } else {
        throw Exception("Gagal upload: ${response.body}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 3. Fungsi Pilih Gambar
  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil gambar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: const Text(
                'POST',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://media.istockphoto.com/id/1495088043/vector/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=612x612&w=0&k=20&c=dhV2p1JwmloBTOaGAtaA3AW1KSnjsdMt7-U_3EZElZ0='),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NAMA USER DINAMIS
                        Text(
                          _userName, 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildDropdownButton(
                              icon: Icons.people,
                              text: _selectedPrivacy,
                              onTap: () => _showPrivacyOptions(),
                            ),
                            const SizedBox(width: 8),
                            _buildDropdownButton(
                              icon: Icons.add,
                              text: _selectedAlbum,
                              onTap: () => _showAlbumOptions(),
                            ),
                            const SizedBox(width: 8),
                            _buildDropdownButton(
                              icon: Icons.location_on,
                              text: _isLocationOn ? 'On' : 'Off',
                              onTap: () => _toggleLocation(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Text Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _postController,
                maxLines: null,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // Preview Gambar
            if (_imageFile != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(_imageFile!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _imageFile = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),

            const SizedBox(height: 20),
            Divider(thickness: 8, color: Colors.grey[100]),

            // Action Buttons
            _buildActionButton(
              icon: Icons.photo_library,
              text: 'Photo/Video',
              color: const Color(0xFFFF6B6B),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            Divider(height: 1, color: Colors.grey[200]),
            _buildActionButton(
              icon: Icons.videocam,
              text: 'Live Video',
              color: const Color(0xFFFF6B6B),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Live Video feature')),
                );
              },
            ),
            Divider(height: 1, color: Colors.grey[200]),
            _buildActionButton(
              icon: Icons.camera_alt,
              text: 'Camera',
              color: const Color(0xFFFF6B6B),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Helper UI ---
  Widget _buildDropdownButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 28),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showPrivacyOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(leading: const Icon(Icons.public), title: const Text('Public'), onTap: () { setState(() => _selectedPrivacy = 'Public'); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.people), title: const Text('Friends'), onTap: () { setState(() => _selectedPrivacy = 'Friends'); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.lock), title: const Text('Only Me'), onTap: () { setState(() => _selectedPrivacy = 'Only Me'); Navigator.pop(context); }),
          ],
        ),
      ),
    );
  }

  void _showAlbumOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Album', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(leading: const Icon(Icons.photo_album), title: const Text('Mobile Uploads'), onTap: () { setState(() => _selectedAlbum = 'Mobile Uploads'); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Profile Pictures'), onTap: () { setState(() => _selectedAlbum = 'Profile Pictures'); Navigator.pop(context); }),
          ],
        ),
      ),
    );
  }

  void _toggleLocation() {
    setState(() {
      _isLocationOn = !_isLocationOn;
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}