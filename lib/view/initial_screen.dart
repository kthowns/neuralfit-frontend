import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/view/login_screen.dart';
import 'package:neuralfit_frontend/view/patient_main_screen.dart';
import 'package:neuralfit_frontend/view/therapist_main_screen.dart';

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
    await Future.delayed(const Duration(seconds: 2)); // 로딩 시뮬레이션

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          if (isPatient) {
            return const PatientMainScreen();
          } else if (isTherapist) {
            return const TherapistMainScreen();
          } else {
            return const ProviderScope(child: LoginScreen());
          }
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
          children: [
            ElevatedButton(
              onPressed: () {
                isPatient = true;
                isTherapist = false;
              },
              child: const Text('Login as Patient'),
            ),
            ElevatedButton(
              onPressed: () {
                isPatient = false;
                isTherapist = true;
              },
              child: const Text('Login as Therapist'),
            ),
            //FlutterLogo(size: 100),
            //SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
