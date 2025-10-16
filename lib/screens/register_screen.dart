import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Halaman registrasi pasien baru
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form key untuk validasi input
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap input field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Status sembunyikan password
  bool _isObscure = true;
  bool _isObscureConfirm = true;

  // Fungsi registrasi akun baru dan menyimpan ke SharedPreferences
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Cek apakah password sama
      if (_passwordController.text != _confirmPasswordController.text) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Konfirmasi password tidak cocok!'),
            backgroundColor: Colors.red[600],
          ),
        );
        return;
      }

      // Simpan data ke local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('phone', _phoneController.text);
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);

      // Tampilkan notifikasi berhasil
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green[700],
        ),
      );

      Navigator.pop(context); // Kembali ke halaman login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Latar belakang gradasi hijau
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 10,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                child: Form(
                  key: _formKey, // Form untuk validasi input
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo rumah sakit
                      Hero(
                        tag: 'logo',
                        child: Image.asset('assets/images/logo.png', height: 90),
                      ),
                      const SizedBox(height: 20),
                      // Judul form registrasi
                      Text(
                        "Registrasi Pasien Baru",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Input nama, telepon, username, password
                      _buildTextField(
                          _nameController, 'Nama Lengkap', Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField(
                          _phoneController, 'No. Telepon', Icons.phone),
                      const SizedBox(height: 15),
                      _buildTextField(
                          _usernameController, 'Username', Icons.account_circle),
                      const SizedBox(height: 15),
                      _passwordField(_passwordController, 'Password', true),
                      const SizedBox(height: 15),
                      _passwordField(_confirmPasswordController,
                          'Konfirmasi Password', false),
                      const SizedBox(height: 25),

                      // Tombol daftar akun
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 5,
                          ),
                          child: const Text(
                            'DAFTAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tombol kembali ke login
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sudah punya akun? Masuk",
                          style: TextStyle(color: Colors.green[800]),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Footer copyright
                      Text(
                        "© 2025 Rumah Sakit Harapan Bunda",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi membuat field teks biasa
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[800]),
        prefixIcon: Icon(icon, color: Colors.green[700]),
        filled: true,
        fillColor: Colors.green[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Masukkan $label';
        return null;
      },
    );
  }

  // Fungsi membuat field password dengan tombol lihat/sembunyi
  Widget _passwordField(
      TextEditingController controller, String label, bool firstField) {
    return TextFormField(
      controller: controller,
      obscureText: firstField ? _isObscure : _isObscureConfirm,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green[800]),
        prefixIcon: Icon(Icons.lock, color: Colors.green[700]),
        suffixIcon: IconButton(
          icon: Icon(
            (firstField ? _isObscure : _isObscureConfirm)
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.green[700],
          ),
          // Mengubah status tampil/sembunyi password
          onPressed: () {
            setState(() {
              if (firstField) {
                _isObscure = !_isObscure;
              } else {
                _isObscureConfirm = !_isObscureConfirm;
              }
            });
          },
        ),
        filled: true,
        fillColor: Colors.green[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Masukkan $label';
        return null;
      },
    );
  }
}
