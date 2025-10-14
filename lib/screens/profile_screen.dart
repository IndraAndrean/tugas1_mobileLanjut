import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navbar.dart';

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Pengguna';
      phone = prefs.getString('phone') ?? '-';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            // Background hijau melengkung
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                color: Colors.green[700],
                padding: EdgeInsets.symmetric(vertical: 40),
                width: double.infinity,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.pink,
                      child: Text(
                        (name.isNotEmpty)
                            ? name[0].toUpperCase()
                            : "U",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      phone,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // List item profil + tombol keluar
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _profileItem(Icons.rule, 'Syarat dan Ketentuan'),
                  _profileItem(Icons.privacy_tip, 'Kebijakan Privasi'),
                  _profileItem(Icons.info_outline, 'Tentang Aplikasi Harbun-Q'),
                  _profileItem(Icons.star, 'Beri Rating Aplikasi Harbun-Q'),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: Text("Konfirmasi Keluar"),
                            content: Text(
                                "Apakah Anda yakin ingin keluar dari aplikasi?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Batal",
                                    style:
                                        TextStyle(color: Colors.grey[700])),
                              ),
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
                                child: Text(
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
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
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

  Widget _profileItem(IconData icon, String title) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {},
      ),
    );
  }
}
