import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 intl 패키지가 필요합니다.

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  AddAppointmentScreenState createState() => AddAppointmentScreenState();
}

class AddAppointmentScreenState extends State<AddAppointmentScreen> {
  // 상태 관리를 위한 변수들
  DateTime _selectedDate = DateTime(2025, 9, 17, 13, 30);
  String _memo = "특이사항 없음";

  // Map을 사용하여 여러 체크박스 상태를 동적으로 관리
  final Map<String, bool> _questionnaires = {
    'IADL': true, // 이미지는 IADL이 기본 체크되어 있음
    'BADL': false,
    'GDS': false,
  };

  // 날짜 포맷터
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진료예약_추가'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 환자 정보
              const Text(
                '이복순 님의 진료 예약',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // 예약 일자
              _buildInfoRow(
                context: context,
                label: '예약 일자',
                value: _dateFormatter.format(_selectedDate),
                icon: Icons.arrow_drop_down,
                onTap: () {
                  // TODO: 실제 날짜/시간 피커 (DatePicker / TimePicker) 로직 구현
                },
              ),
              const SizedBox(height: 16),

              // 메모
              _buildInfoRow(
                context: context,
                label: '메모',
                value: _memo,
                icon: Icons.edit_outlined,
                onTap: () {
                  // TODO: 메모 수정 화면으로 이동 또는 다이얼로그 표시
                },
              ),

              // 구분선
              const Divider(height: 48),

              // 환자 사전 문진 섹션
              const Text(
                '환자 사전 문진',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 문진 항목 그룹
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2), // 이미지와 유사한 회색 배경
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildCheckboxTile(
                      key: 'IADL',
                      title: 'IADL',
                      subtitle: '(일상 도구 활용 능력)',
                    ),
                    _buildCheckboxTile(
                      key: 'BADL',
                      title: 'BADL',
                      subtitle: '(일상생활 수행 능력)',
                    ),
                    _buildCheckboxTile(
                      key: 'GDS',
                      title: 'GDS',
                      subtitle: '(우울 척도)',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // 하단 '추가' 버튼
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            final selectedSurveys = _questionnaires.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();

            print('예약 추가됨. 선택된 사전 문진: $selectedSurveys');
          },
          child: const Text('추가'),
        ),
      ),
    );
  }

  /// 정보 행 (예약 일자, 메모)을 만드는 헬퍼 위젯
  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.grey),
        ],
      ),
    );
  }

  /// 사전 문진 체크박스 타일을 만드는 헬퍼 위젯
  Widget _buildCheckboxTile({
    required String key,
    required String title,
    required String subtitle,
  }) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54)),
      value: _questionnaires[key],
      onChanged: (bool? newValue) {
        if (newValue != null) {
          setState(() {
            _questionnaires[key] = newValue;
          });
        }
      },
      controlAffinity: ListTileControlAffinity.trailing, // 체크박스를 오른쪽으로
      activeColor: Colors.blue, // 체크됐을 때 색상
    );
  }
}
