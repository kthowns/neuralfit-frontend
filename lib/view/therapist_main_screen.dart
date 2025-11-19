import 'package:flutter/material.dart';

// 더미 환자 데이터 모델
class Patient {
  final String name;
  final String dob;

  Patient({required this.name, required this.dob});
}

class TherapistMainScreen extends StatefulWidget {
  const TherapistMainScreen({super.key});

  @override
  State<TherapistMainScreen> createState() => _TherapistMainScreenState();
}

class _TherapistMainScreenState extends State<TherapistMainScreen> {
  final List<Patient> _patients = [
    Patient(name: '이 복 순', dob: '1970-01-01'),
    Patient(name: '김 철 수', dob: '1985-05-15'),
    Patient(name: '박 영 희', dob: '1992-11-30'),
  ];

  // 2. PageView 컨트롤러
  final PageController _pageController = PageController();

  // 3. AppBar 토글 버튼 상태 ('로그' = 0, '??' = 1)
  int _selectedToggleIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  // --- 로직 영역 끝 ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _patients.isEmpty
          ? _buildEmptyState() // 환자가 없을 때
          : _buildPatientList(), // 환자가 있을 때
    );
  }

  /// 1. 앱바 (AppBar) 빌드
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        onPressed: () {
          // --- 로직: 뒤로가기 ---
          // print('Back button pressed');
        },
      ),
      title: ToggleButtons(
        isSelected: [_selectedToggleIndex == 0, _selectedToggleIndex == 1],
        onPressed: (index) {},
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.black, // 선택된 텍스트 색
        color: Colors.black54, // 선택 안된 텍스트 색
        fillColor: Colors.white, // 선택된 배경 색
        renderBorder: false,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text('로그'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text('??'), // 와이어프레임의 두 번째 탭
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Badge(
            label: const Text('1'), // 알림 배지
            child: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.black87,
              size: 28,
            ),
          ),
          onPressed: () {
            // --- 로직: 알림 버튼 클릭 ---
            // print('Notification button pressed');
          },
        ),
      ],
    );
  }

  /// 2. 환자 목록이 비어있을 때 (Empty State)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_off_outlined, // '연결된 환자 없음' 아이콘
              size: 80,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '아직 연결된 환자가 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  /// 3. 환자 목록이 있을 때 (PageView)
  Widget _buildPatientList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 왼쪽 화살표
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () {
            // --- 로직: 이전 페이지로 ---
            // _pageController.previousPage(
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeInOut,
            // );
          },
        ),

        // 환자 카드 PageView
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _patients.length,
            itemBuilder: (context, index) {
              // PageView 내부에 패딩을 주어 카드가 중앙에 위치하도록 함
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 8.0,
                ),
                child: _buildPatientCard(_patients[index]),
              );
            },
            onPageChanged: (index) {
              // --- 로직: 페이지 변경 시 ---
              // print('Current patient index: $index');
            },
          ),
        ),

        // 오른쪽 화살표
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onPressed: () {
            // --- 로직: 다음 페이지로 ---
            // _pageController.nextPage(
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeInOut,
            // );
          },
        ),
      ],
    );
  }

  /// 4. 개별 환자 카드
  Widget _buildPatientCard(Patient patient) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, // 컬럼 중앙 정렬
          children: [
            // 상단 '...' (더보기) 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onPressed: () {
                    // --- 로직: 더보기 버튼 ---
                    // print('More options pressed for ${patient.name}');
                  },
                ),
              ],
            ),

            // 아바타와 우측 태그 (Stack으로 구현)
            Stack(
              clipBehavior: Clip.none, // 스택 밖으로 태그가 나가도 보이도록
              alignment: Alignment.center,
              children: [
                // 프로필 아이콘
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xFFE0E0E0), // 라이트 그레이
                  child: Icon(
                    Icons.person,
                    size: 90,
                    color: Color(0xFF424242), // 다크 그레이
                  ),
                ),

                // '연결 끊기' & '하트' (아바타 우측 상단)
                Positioned(
                  top: 5,
                  right: -35, // 아바타 기준 오른쪽으로 35px
                  child: Column(
                    children: [
                      Chip(
                        label: const Text(
                          '연결 끊기',
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        ),
                        backgroundColor: Colors.red[50],
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        side: BorderSide.none,
                      ),
                      const SizedBox(height: 8),
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 환자 이름
            Text(
              patient.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 환자 생년월일
            Text(
              patient.dob,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const Spacer(), // 남은 공간을 모두 차지
            // 하단 버튼
            _buildRecordButton('진료 기록'),
            const SizedBox(height: 12),
            _buildRecordButton('진료 예약'),

            const SizedBox(height: 16), // 카드 하단 여백
          ],
        ),
      ),
    );
  }

  /// 5. 공통 버튼 위젯 (진료 기록, 진료 예약)
  Widget _buildRecordButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // --- 로직: 버튼 클릭 ---
          // print('$text 버튼 클릭');
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
