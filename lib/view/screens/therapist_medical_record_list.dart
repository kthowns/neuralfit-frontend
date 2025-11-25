import 'package:flutter/material.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';

// 진료 기록 상태 Enum
enum AiReportStatus {
  approved, // 승인 완료
  pending, // 승인 대기
  generating, // 생성 중
}

// 진료 기록 데이터를 위한 모델 정의
class MedicalRecord {
  final DateTime date;
  final String title;
  final String detail;
  final AiReportStatus status;

  MedicalRecord({
    required this.date,
    required this.title,
    required this.detail,
    required this.status,
  });
}

// MedicalRecordListScreen을 StatefulWidget으로 변경하여 상태 관리가 가능하도록 합니다.
class MedicalRecordListScreen extends StatefulWidget {
  final PatientInfo patientInfo;

  const MedicalRecordListScreen({super.key, required this.patientInfo});

  @override
  State<MedicalRecordListScreen> createState() =>
      _MedicalRecordListScreenState();
}

class _MedicalRecordListScreenState extends State<MedicalRecordListScreen> {
  // 현재 선택된 년/월을 저장할 상태 변수 (기본값: 현재 날짜)
  DateTime _selectedDate = DateTime(2025, 9, 1);

  // 설정 가능한 최소/최대 년도
  static const int minYear = 2020;
  static const int maxYear = 2030;

  // 요일 변환 함수
  String _getWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }

  // AI 리포트 상태에 따른 텍스트 및 색상 반환
  (String, Color) _getStatusInfo(AiReportStatus status) {
    switch (status) {
      case AiReportStatus.approved:
        return ('AI 리포트 승인 완료', Colors.blue);
      case AiReportStatus.pending:
        return ('AI 리포트 승인 대기', Colors.orange);
      case AiReportStatus.generating:
        return ('AI 리포트 생성 중', Colors.grey);
      default:
        return ('상태 정보 없음', Colors.grey);
    }
  }

  // 년도와 월만 선택하는 커스텀 다이얼 선택기
  Future<void> _selectMonthYear(BuildContext context) async {
    // 현재 선택된 년도와 월의 초기 인덱스 계산
    int initialYearIndex = _selectedDate.year - minYear;
    int initialMonthIndex = _selectedDate.month - 1;

    // 임시 변수에 현재 선택 값을 저장
    int tempYear = _selectedDate.year;
    int tempMonth = _selectedDate.month;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250.0,
          color: Colors.white,
          child: Column(
            children: [
              // 1. 확인/취소 버튼 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 취소
                    },
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // 최종 선택된 년도와 월로 상태 업데이트
                        _selectedDate = DateTime(tempYear, tempMonth, 1);
                        print('선택된 날짜: $_selectedDate');
                        // TODO: 이 날짜를 기반으로 리스트 필터링
                      });
                      Navigator.pop(context); // 확인
                    },
                    child: const Text(
                      '확인',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              // 2. 년/월 스피너 영역
              Expanded(
                child: Row(
                  children: <Widget>[
                    // 년도 스피너
                    Expanded(
                      child: Center(
                        child: YearPickerSpinner(
                          minYear: minYear,
                          maxYear: maxYear,
                          initialIndex: initialYearIndex,
                          onChanged: (year) {
                            tempYear = year;
                          },
                        ),
                      ),
                    ),
                    // 월 스피너
                    Expanded(
                      child: Center(
                        child: MonthPickerSpinner(
                          initialIndex: initialMonthIndex,
                          onChanged: (month) {
                            tempMonth = month;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 플레이스홀더 데이터 (와이어프레임에 맞춰 구성)
    final List<MedicalRecord> _records = [
      MedicalRecord(
        date: DateTime(2025, 9, 4), // 9월 4일 (목)
        title: '[진료] 2025-09-04(목)',
        detail: '특이사항 없음',
        status: AiReportStatus.approved,
      ),
      MedicalRecord(
        date: DateTime(2025, 9, 17), // 9월 17일 (수)
        title: '[진료] 2025-09-17(수)',
        detail: '환자 BADL 평가 수준 낮음, 조치 필요',
        status: AiReportStatus.pending,
      ),
      MedicalRecord(
        date: DateTime(2025, 9, 29), // 9월 29일 (월)
        title: '[진료] 2025-09-29(월)',
        detail: '특이사항 없음',
        status: AiReportStatus.generating,
      ),
    ];

    // 현재 선택된 날짜를 'YYYY. MM' 형식으로 포맷
    final formattedMonthYear =
        '${_selectedDate.year}. ${_selectedDate.month.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('진료 기록'),
        centerTitle: false,
      ),
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
              '이복순님의 진료기록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),

          // 2. 필터링 및 정렬 영역 (커스텀 스피너 버튼)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 캘린더/월 필터 (버튼으로 대체)
                InkWell(
                  onTap: () => _selectMonthYear(context), // 커스텀 스피너 호출
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedMonthYear, // 현재 선택된 년/월 표시
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down), // 드롭다운 아이콘 추가
                    ],
                  ),
                ),

                // 정렬 필터 (기존 유지)
                Row(
                  children: [
                    const Icon(Icons.sort, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    DropdownButton<String>(
                      value: '최신순',
                      items: const [
                        DropdownMenuItem(value: '최신순', child: Text('최신순')),
                        DropdownMenuItem(value: '과거순', child: Text('과거순')),
                      ],
                      onChanged: (String? newValue) {
                        // TODO: 정렬 로직 구현
                      },
                      underline: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. 진료 기록 리스트 영역
          Expanded(
            child: _records.isEmpty
                ? const Center(
                    child: Text(
                      '진료 기록이 없습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      return MedicalRecordListItem(
                        record: _records[index],
                        getWeekday: _getWeekday,
                        getStatusInfo: _getStatusInfo,
                      );
                    },
                  ),
          ),
        ],
      ),

      // 4. Floating Action Button (새 기록 추가)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('새 진료 기록 추가');
        },
        backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// 년도 선택을 위한 커스텀 스피너 위젯
class YearPickerSpinner extends StatefulWidget {
  final int minYear;
  final int maxYear;
  final int initialIndex;
  final ValueChanged<int> onChanged;

  const YearPickerSpinner({
    super.key,
    required this.minYear,
    required this.maxYear,
    required this.initialIndex,
    required this.onChanged,
  });

  @override
  State<YearPickerSpinner> createState() => _YearPickerSpinnerState();
}

class _YearPickerSpinnerState extends State<YearPickerSpinner> {
  late FixedExtentScrollController _scrollController;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.minYear + widget.initialIndex;
    _scrollController = FixedExtentScrollController(
      initialItem: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    int yearCount = widget.maxYear - widget.minYear + 1;

    return ListWheelScrollView.useDelegate(
      controller: _scrollController,
      itemExtent: 40,
      perspective: 0.003,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        _selectedYear = widget.minYear + index;
        widget.onChanged(_selectedYear);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: yearCount,
        builder: (context, index) {
          final year = widget.minYear + index;
          return Center(
            child: Text(
              '$year 년',
              style: TextStyle(
                fontSize: 20,
                color: year == _selectedYear ? Colors.black : Colors.grey,
                fontWeight: year == _selectedYear
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}

// 월 선택을 위한 커스텀 스피너 위젯
class MonthPickerSpinner extends StatefulWidget {
  final int initialIndex; // 0 (1월) ~ 11 (12월)
  final ValueChanged<int> onChanged; // 1월~12월로 반환

  const MonthPickerSpinner({
    super.key,
    required this.initialIndex,
    required this.onChanged,
  });

  @override
  State<MonthPickerSpinner> createState() => _MonthPickerSpinnerState();
}

class _MonthPickerSpinnerState extends State<MonthPickerSpinner> {
  late FixedExtentScrollController _scrollController;
  late int _selectedMonthIndex;

  @override
  void initState() {
    super.initState();
    _selectedMonthIndex = widget.initialIndex;
    _scrollController = FixedExtentScrollController(
      initialItem: widget.initialIndex,
    );
    // 초기값 변경 알림
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(_selectedMonthIndex + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _scrollController,
      itemExtent: 40,
      perspective: 0.003,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        _selectedMonthIndex = index;
        widget.onChanged(index + 1); // 1~12월로 변환하여 전달
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 12,
        builder: (context, index) {
          final month = index + 1;
          return Center(
            child: Text(
              '${month.toString().padLeft(2, '0')} 월',
              style: TextStyle(
                fontSize: 20,
                color: index == _selectedMonthIndex
                    ? Colors.black
                    : Colors.grey,
                fontWeight: index == _selectedMonthIndex
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}

// MedicalRecordListItem 위젯은 변경 없이 그대로 유지됩니다.
class MedicalRecordListItem extends StatelessWidget {
  final MedicalRecord record;
  final String Function(DateTime) getWeekday;
  final (String, Color) Function(AiReportStatus) getStatusInfo;

  const MedicalRecordListItem({
    required this.record,
    required this.getWeekday,
    required this.getStatusInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (statusText, statusColor) = getStatusInfo(record.status);
    final formattedDate =
        '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}(${getWeekday(record.date)})';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: InkWell(
          onTap: () {
            print('기록 상세 보기: ${record.title}');
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.black54,
                      size: 20,
                    ), // 문서 아이콘
                    const SizedBox(width: 8),
                    // 진료 날짜 및 제목
                    Expanded(
                      child: Text(
                        record.title.isEmpty
                            ? '[진료] $formattedDate'
                            : record.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // 상세 내용
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    record.detail,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // AI 리포트 상태
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
