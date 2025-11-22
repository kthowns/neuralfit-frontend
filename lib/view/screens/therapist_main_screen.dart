import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/view/screens/therapist_setting_screen.dart';
import 'package:neuralfit_frontend/view/widgets/patient_card.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class TherapistMainScreen extends ConsumerStatefulWidget {
  final currentIndex = 0;
  const TherapistMainScreen({super.key});

  @override
  ConsumerState<TherapistMainScreen> createState() =>
      _TherapistMainScreenState();
}

class _TherapistMainScreenState extends ConsumerState<TherapistMainScreen> {
  @override
  Widget build(BuildContext context) {
    final therapistMainState = ref.watch(therapistMainViewModelProvider);
    final therapistMainViewModel = ref.read(
      therapistMainViewModelProvider.notifier,
    );

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TherapistSettingScreen(),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
      appBar: AppBar(
        title: const Text('환자 관리'),
        actions: <Widget>[
          // 알림 버튼 (아이콘 배지 추가 가능)
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // 알림 페이지로 이동 로직
              print('알림 버튼 클릭');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await therapistMainViewModel.fetchPatients();
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        maxHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: PageView.builder(
                              itemCount: therapistMainState.patients.length,
                              controller: PageController(
                                viewportFraction: 0.85,
                              ),
                              itemBuilder: (context, index) {
                                // ... PatientCard 렌더링 로직
                                return Center(
                                  child: PatientCard(
                                    patient: therapistMainState.patients[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 페이지 인디케이터 (선택 사항)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(therapistMainState.patients.length, (
              index,
            ) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 2.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
