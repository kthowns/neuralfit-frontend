import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/view/screens/patient_medical_record_list.dart';
import 'package:neuralfit_frontend/view/screens/patient_setting_screen.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class PatientMainScreen extends ConsumerStatefulWidget {
  const PatientMainScreen({super.key});

  @override
  ConsumerState<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends ConsumerState<PatientMainScreen> {
  // 예시 데이터
  final List<String> dailyActivities = [
    "오늘의 인지력 강화 가이드: 퍼즐 맞추기 30분!",
    "치매 예방 액티비티: 가벼운 산책 20분",
    "생활 습관 개선 가이드: 충분한 수면 7시간",
  ];
  int _currentActivityIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);
    final patientMainViewmodel = ref.read(
      patientMainViewmodelProvider.notifier,
    );
    final patientMainState = ref.watch(patientMainViewmodelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '안녕하세요, ${authState.userInfo?.name}님!', // 개인화된 환영 메시지
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // TODO: 알림 페이지로 이동
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 오늘의 핵심 정보/가이드 (AI 생성 인사이트)
            _buildSectionTitle('오늘의 AI 건강 인사이트'),
            _buildInsightCard(context),
            const SizedBox(height: 24),

            // 2. 다음 진료 예약 및 문진표 작성
            _buildSectionTitle('나의 진료 일정'),
            _buildAppointmentCard(context),
            const SizedBox(height: 24),

            // 3. 리마인더 섹션
            _buildSectionTitle('내 리마인더'),
            _buildReminderList(),
            const SizedBox(height: 24),

            // 4. 자가 기록 (인지 저하 가능성 자가 점검)
            _buildSectionTitle('오늘의 자가 점검'),
            _buildSelfCheckCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 아이템 수가 많을 때 사용
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // 현재 선택된 탭
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientMedicalRecordListScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientSettingScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '메인'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: '리포트'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '진료',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }

  // 섹션 제목을 위한 헬퍼 위젯
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // AI 생성 인사이트 카드
  Widget _buildInsightCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // 트렌디한 그라데이션
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '오늘의 인지력 강화 가이드',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dailyActivities[_currentActivityIndex], // 슬라이드 효과를 줄 수 있음
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: AI 인사이트 상세 페이지로 이동
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('자세히 보기 >', style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 다음 진료 예약 카드
  Widget _buildAppointmentCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '다음 진료 예약: 2025년 9월 18일 (목) 오후 2시',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              '김철수 교수님 | 신경과',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: 문진표 작성 페이지로 이동
                },
                icon: const Icon(Icons.edit_note),
                label: const Text(
                  '문진표 미리 작성하기',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // 버튼 색상
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 리마인더 목록
  Widget _buildReminderList() {
    return Column(
      children: [
        _buildReminderItem(Icons.medication, '오후 6시 약 복용', '치매약 1정'),
        _buildReminderItem(
          Icons.calendar_today,
          '다음 검사: 2025년 10월 5일',
          '정기 인지 기능 검사',
        ),
        // 더 많은 리마인더는 ListView.builder로 처리
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // TODO: 전체 리마인더 페이지로 이동
            },
            child: const Text(
              '전체 리마인더 보기 >',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // 개별 리마인더 아이템
  Widget _buildReminderItem(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 자가 점검 카드 (BADL, GDS 등 단순 설문)
  Widget _buildSelfCheckCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '오늘의 컨디션은 어떠신가요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // 예시: 슬라이더 또는 이모티콘 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEmotionButton('매우 좋음', '😊', () {}),
                _buildEmotionButton('좋음', '🙂', () {}),
                _buildEmotionButton('보통', '😐', () {}),
                _buildEmotionButton('나쁨', '😟', () {}),
                _buildEmotionButton('매우 나쁨', '😩', () {}),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 자가 점검 설문 페이지로 이동 또는 기록 저장
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent, // 버튼 색상
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '오늘의 상태 기록하기',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 감정 선택 버튼 (자가 점검용)
  Widget _buildEmotionButton(String label, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
