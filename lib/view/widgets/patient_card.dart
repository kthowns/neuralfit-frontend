import 'package:flutter/material.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';

class PatientCard extends StatelessWidget {
  final PatientInfo patient;
  final bool isActive;

  const PatientCard({required this.patient, this.isActive = false, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      // 활성화된 카드에 약간의 elevation 변화를 줄 수 있습니다.
      child: Card(
        elevation: isActive ? 12.0 : 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- 1. 사진(Image Text) 및 PopupMenuButton 영역 ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 사진 (공백에 Image Text로 대체)
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: const CircleAvatar(
                      radius: 70,
                      backgroundColor: Color(0xFFE0E0E0), // 라이트 그레이
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Color(0xFF424242), // 다크 그레이
                      ),
                    ),
                  ),
                  const Spacer(), // 빈 공간 채우기
                  // PopupMenuButton (연결 끊기 옵션)
                  PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'disconnect') {
                        print('${patient.name} 환자 연결 끊기');
                        // 연결 끊기 로직 구현
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'disconnect',
                            child: Text('연결 끊기'),
                          ),
                        ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- 2. 이름 및 생년월일 영역 ---
              Text(
                patient.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '생년월일: ${patient.birthDate.year}-${patient.birthDate.month.toString().padLeft(2, '0')}-${patient.birthDate.day.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),

              // --- 3. 버튼 영역 ---
              // 진료기록 목록 페이지로 가는 버튼
              ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('진료기록 목록 확인'),
                onPressed: () {
                  print('${patient.name} 진료기록 페이지로 이동');
                  // Navigator.push를 사용하여 해당 페이지로 이동
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 진료 예약 목록 페이지로 가는 버튼
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Text('진료 예약 목록 확인'),
                onPressed: () {
                  print('${patient.name} 진료 예약 페이지로 이동');
                  // Navigator.push를 사용하여 해당 페이지로 이동
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
