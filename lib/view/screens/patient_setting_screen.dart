import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/view/screens/initial_screen.dart';
import 'package:neuralfit_frontend/viewmodel/patient_code_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class PatientSettingScreen extends ConsumerStatefulWidget {
  const PatientSettingScreen({super.key});

  @override
  ConsumerState<PatientSettingScreen> createState() => PatientSettingState();
}

class PatientSettingState extends ConsumerState<PatientSettingScreen> {
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    final patientCodeState = ref.watch(patientCodeStateProvider);
    final patientCodeViewmodel = ref.read(patientCodeStateProvider.notifier);
    final authStateNotifier = ref.read(authStateNotifierProvider.notifier);

    ref.listen<PatientCodeState>(patientCodeStateProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              next.errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
        );

        patientCodeViewmodel.setErrorMessage('');
      }
    });

    void tryConnectButtonClicked() async {
      await patientCodeViewmodel.tryConnect();

      if (patientCodeState.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              patientCodeState.errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        patientCodeViewmodel.setErrorMessage('');
      } else {
        setState(() {
          _isConnected = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text("연결 되었습니다!", style: TextStyle(color: Colors.green)),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. 초대 코드 관리 섹션 ---
            const Text(
              '환자 초대 코드 관리',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const Divider(height: 20, thickness: 1),

            // 2. 현재 코드 표시 및 복사 영역
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "초대 코드",
                  hintText: "초대코드를 입력해주세요.",
                ),
                onChanged: (value) {
                  patientCodeViewmodel.setCode(value);
                },
              ),
            ),
            const SizedBox(height: 20),

            // 3. 새 코드 생성 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('연결하기'),
                onPressed: _isConnected ? null : tryConnectButtonClicked,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              '계정 및 앱 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              title: const Text('비밀번호 변경'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                /* ... */
              },
            ),
            ListTile(
              title: const Text('로그아웃'),
              trailing: const Icon(Icons.exit_to_app, size: 16),
              onTap: () {
                authStateNotifier.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => InitialScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
