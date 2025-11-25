import 'package:flutter/material.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';
import 'package:neuralfit_frontend/view/screens/add_appointment_screen.dart';

// 예약 데이터를 위한 간단한 모델 정의
class Appointment {
  final String date;
  final String time;
  final String type;
  final bool isConfirmed;

  Appointment({
    required this.date,
    required this.time,
    required this.type,
    required this.isConfirmed,
  });
}

class AppointmentListScreen extends StatelessWidget {
  final PatientInfo patient;

  const AppointmentListScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    // 플레이스홀더 데이터 (실제 데이터는 Viewmodel에서 로드됨)
    final List<Appointment> _appointments = [
      Appointment(
        date: '2025.09.15',
        time: '오전 10:30',
        type: '재활 상담',
        isConfirmed: true,
      ),
      Appointment(
        date: '2025.09.22',
        time: '오후 02:00',
        type: '초진',
        isConfirmed: false,
      ),
      Appointment(
        date: '2025.10.05',
        time: '오전 09:00',
        type: '정기 검진',
        isConfirmed: true,
      ),
    ];

    // 데이터가 비어있을 때를 위한 테스트 (주석 해제 시 빈 화면 확인 가능)
    // final List<Appointment> _appointments = [];

    return Scaffold(
      appBar: AppBar(
        // 뒤로가기 버튼
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // ⭐️ 타이틀 변경
        title: const Text('진료 예약'),
        centerTitle: false,
      ),

      // Floating Action Button을 화면 최상단에 배치하기 위해 Stack 대신 Column 사용 (Scaffold의 body 영역)
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 환자 정보 헤더 영역
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              // ⭐️ 텍스트 변경
              '이복순님의 진료 예약',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),

          // 2. 필터링 및 정렬 영역
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 캘린더/월 필터
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: '2025. 09',
                      items: const [
                        DropdownMenuItem(
                          value: '2025. 09',
                          child: Text('2025. 09'),
                        ),
                        DropdownMenuItem(
                          value: '2025. 10',
                          child: Text('2025. 10'),
                        ),
                      ],
                      onChanged: (String? newValue) {},
                      underline: Container(), // 드롭다운 밑줄 제거
                    ),
                  ],
                ),

                // 정렬 필터
                Row(
                  children: [
                    const Icon(Icons.sort, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    DropdownButton<String>(
                      value: '최신순',
                      items: const [
                        DropdownMenuItem(value: '최신순', child: Text('최신순')),
                        DropdownMenuItem(value: '예정일순', child: Text('예정일순')),
                      ],
                      onChanged: (String? newValue) {},
                      underline: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. 리스트 또는 Empty 상태 영역 (남은 공간 모두 차지)
          Expanded(
            child: _appointments.isEmpty
                ? const Center(
                    child: Text(
                      // ⭐️ 텍스트 변경
                      '진료 예약이 없습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _appointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentListItem(
                        appointment: _appointments[index],
                      );
                    },
                  ),
          ),
        ],
      ),

      // 4. Floating Action Button (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// 진료 예약 목록 항목 위젯
class AppointmentListItem extends StatelessWidget {
  final Appointment appointment;

  const AppointmentListItem({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    // 예약 상태에 따라 색상과 텍스트를 결정
    Color statusColor = appointment.isConfirmed ? Colors.green : Colors.orange;
    String statusText = appointment.isConfirmed ? '예약 확정' : '확인 대기';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.access_time_filled, color: statusColor),
        title: Text(
          '${appointment.date} ${appointment.time}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${appointment.type} | 상태: $statusText',
          style: TextStyle(color: statusColor, fontSize: 13),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          print('${appointment.date} 예약 상세 보기');
        },
      ),
    );
  }
}
