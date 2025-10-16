import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navbar.dart';

// Membuat custom clipper agar header memiliki bentuk lengkung
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Membuat kurva di bagian bawah header
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  // Tidak perlu menggambar ulang clip ketika ukuran berubah
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Halaman profil pengguna
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variabel untuk menyimpan nama dan nomor telepon pengguna
  String name = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Memanggil fungsi untuk memuat data profil tersimpan
  }

  // Fungsi untuk memuat data nama & telepon dari SharedPreferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // Pastikan widget masih aktif sebelum update UI
    setState(() {
      name = prefs.getString('name') ?? 'Pengguna';
      phone = prefs.getString('phone') ?? '-';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan bottom navigation bar
      bottomNavigationBar: const BottomNavbar(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian header profil dengan background hijau dan bentuk melengkung
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                color: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                child: Column(
                  children: [
                    // Foto profil bulat (avatar) menampilkan huruf depan nama
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.pink,
                      child: Text(
                        (name.isNotEmpty) ? name[0].toUpperCase() : "U",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Menampilkan nama pengguna
                    Text(
                      name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    // Menampilkan nomor telepon pengguna
                    Text(
                      phone,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // Daftar menu di bawah profil
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _profileItem(Icons.rule, 'Syarat dan Ketentuan'),
                  _profileItem(Icons.privacy_tip, 'Kebijakan Privasi'),
                  _profileItem(Icons.info_outline, 'Tentang Aplikasi Harbun-Q'),
                  _profileItem(Icons.star, 'Beri Rating Aplikasi Harbun-Q'),
                  const SizedBox(height: 20),

                  // Tombol keluar aplikasi
                  ElevatedButton(
                    onPressed: () {
                      // Menampilkan dialog konfirmasi keluar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: const Text("Konfirmasi Keluar"),
                            content: const Text(
                                "Apakah Anda yakin ingin keluar dari aplikasi?"),
                            actions: [
                              // Tombol batal keluar
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Batal",
                                    style:
                                        TextStyle(color: Colors.grey[700])),
                              ),
                              // Tombol konfirmasi keluar menuju halaman login
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                child: const Text(
                                  "Keluar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'KELUAR',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembuat widget item profil (seperti menu S&K, Privasi, dll)
  Widget _profileItem(IconData icon, String title) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {},
      ),
    );
  }
}
