import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

// Halaman splash (logo awal aplikasi)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menunggu 3 detik sebelum pindah ke halaman login
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  // Tampilan logo utama aplikasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(
        child: Hero(
          tag: 'logo',
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 300,
          ),
        ),
      ),
    );
  }
}
