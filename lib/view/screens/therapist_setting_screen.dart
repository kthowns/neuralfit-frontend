import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:neuralfit_frontend/view/screens/initial_screen.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart'; // 클립보드 복사를 위해 필요

class TherapistSettingScreen extends ConsumerWidget {
  const TherapistSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final therapistCodeState = ref.watch(therapistCodeViewModelProvider);
    final therapistCodeViewModel = ref.read(
      therapistCodeViewModelProvider.notifier,
    );
    final authStateNotifier = ref.read(authStateNotifierProvider.notifier);

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('현재 초대 코드:', style: TextStyle(fontSize: 16)),
                  SelectableText(
                    // 코드를 길게 눌러 선택할 수 있게 함
                    therapistCodeState.code.isNotEmpty
                        ? therapistCodeState.code
                        : "...",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    color: Colors.grey,
                    onPressed: () {
                      // 💡 클립보드 복사 로직
                      Clipboard.setData(
                        ClipboardData(text: therapistCodeState.code),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('초대 코드가 복사되었습니다.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. 새 코드 생성 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('새 초대 코드 생성'),
                onPressed: () {
                  // 💡 Viewmodel 호출하여 새 코드 생성 로직 실행
                  therapistCodeViewModel.generateNewCode();
                },
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
