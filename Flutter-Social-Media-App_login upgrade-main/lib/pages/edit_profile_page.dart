import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller dengan teks default kosong dulu (akan diisi dari database)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _bioController = TextEditingController(text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Ambil data saat halaman dibuka
  }

  // 1. Fungsi Mengambil Data User (Agar form terisi nama user yang login)
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? "";
      _emailController.text = prefs.getString('email') ?? "";
    });
  }

  // Fungsi Menyimpan Data ke Database (Laravel)
  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Variabel ini sekarang AKAN dipakai
    
    // Ip backend
    const String apiUrl = 'http://10.0.2.2:8000/api/user/update'; 

    try {
      // 1. Kirim request ke Backend Laravel (Kode dihidupkan kembali)
      if (token != null) {
        // Request Update ke Server
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $token', // Menggunakan variabel token
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'name': _nameController.text,
            'email': _emailController.text,
          }),
        );

        if (response.statusCode != 200) {
          throw Exception('Gagal update di server: ${response.body}');
        }

        if (response.statusCode == 200) {
          // B. Jika Sukses di Server, Simpan di Lokal (SharedPreferences)
          await prefs.setString('name', _nameController.text);
          await prefs.setString('email', _emailController.text); // Update email di memori HP

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile & Email updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Kembali ke halaman sebelumnya dengan sinyal refresh (true)
            Navigator.pop(context, true); 
          }
        } else {
          // Handle Error dari Laravel (misal email sudah dipakai orang lain)
          final errorData = jsonDecode(response.body);
          String msg = errorData.toString();
          if (errorData is Map && errorData['email'] != null) {
            msg = errorData['email'][0]; // Ambil pesan error spesifik email
          }
          throw Exception(msg);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // Tombol Save (Centang)
          _isLoading
              ? const Center(child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)),
                ))
              : IconButton(
                  icon: const Icon(Icons.check, color: Colors.black, size: 28),
                  onPressed: _saveProfile, // Panggil fungsi simpan
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Photo
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: const [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://media.istockphoto.com/id/1495088043/vector/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=612x612&w=0&k=20&c=dhV2p1JwmloBTOaGAtaA3AW1KSnjsdMt7-U_3EZElZ0=',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: _changeProfilePhoto,
              child: const Text(
                'Change profile photo',
                style: TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Name Field
            _buildTextField(
              label: 'Name',
              controller: _nameController,
            ),

            const SizedBox(height: 20),

            // Username Field (Email)
            _buildTextField(
              label: 'Username / Email',
              controller: _emailController,
            ),

            const SizedBox(height: 20),

            // Website Field
            _buildTextField(
              label: 'Website',
              controller: _websiteController,
            ),

            const SizedBox(height: 20),

            // Bio Field
            _buildTextField(
              label: 'Bio',
              controller: _bioController,
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            // Add Link
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add Link',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 30),

            _buildActionLink(
              'Switch to professional account',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Switch to professional account')),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildActionLink(
              'Create avatar',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create avatar')),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildActionLink(
              'Personal information settings',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Personal information settings')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper UI (Sama persis dengan aslinya)
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF6C5CE7),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _changeProfilePhoto() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF6C5CE7)),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Photo captured: ${image.name}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error capturing photo')),
                    );
                  }
                }
              },
            ),
            // ... (Kode kamera/galeri lainnya tetap sama)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}