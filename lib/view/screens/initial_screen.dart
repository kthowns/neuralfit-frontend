import 'package:flutter/material.dart';
import 'package:neuralfit_frontend/view/screens/login_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool isPatient = false;
  bool isTherapist = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  get isLoggedIn => () {
    // 실제로는 토큰 검증 로직 등
    return false;
  };

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 1)); // 로딩 시뮬레이션

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return const LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const CircularProgressIndicator()],
        ),
      ),
    );
  }
}
