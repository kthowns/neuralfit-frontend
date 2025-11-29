import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class TherapistAddRecordScreen extends StatefulWidget {
  const TherapistAddRecordScreen({super.key});

  @override
  State<TherapistAddRecordScreen> createState() => _TherapistAddRecordState();
}

class _TherapistAddRecordState extends State<TherapistAddRecordScreen> {
  // --- State Variables ---

  // 1. DX (Diagnosis)
  int _dxIndex = 1; // 와이어프레임처럼 '경도인지장애'를 기본 선택으로 가정
  final List<String> dxLabels = [
    '정상 (Normal)',
    '경도인지장애 (MCI)',
    '치매 경도 (Mild)',
    '치매 중증 (Severe)',
  ];

  bool _isMemoEditing = false;

  // 2. 생체 검사 데이터
  bool _isBiomarkerExpanded = true;
  final TextEditingController _abetaController = TextEditingController();
  final TextEditingController _ptauController = TextEditingController();
  final TextEditingController _mriMemoController =
      TextEditingController(); // MRI 이미지 데이터 메모

  // 3. 인지기능검사 결과 (정수형 슬라이더 및 필드)
  // 와이어프레임처럼 MMSE와 MOCA는 확장/축소 상태를 가집니다.
  bool _isMmseExpanded = false;
  bool _isMocaExpanded = false;
  bool _isFaqExpanded = false;
  bool _isAdas13Expanded = false;
  bool _isLdelTotalExpanded = false;

  double _mocaValue = 15; // 0~30
  double _faqValue = 5; // 0~30
  double _mmseValue = 20; // 0~30
  double _ldelTotalValue = 10; // 0~25
  double _adas13Value = 30; // 0~85

  // 기타
  DateTime _selectedDate = DateTime(2025, 8, 17); // 와이어프레임 날짜 참고
  TimeOfDay _selectedTime = const TimeOfDay(
    hour: 13,
    minute: 30,
  ); // 와이어프레임 시간 참고
  final TextEditingController _memoController = TextEditingController(
    text: '특이사항 없음',
  );
  final TextEditingController _patientCommentController =
      TextEditingController();

  // --- UI Component Builders ---

  // DX (진단 구분) 단계 인디케이터 (와이어프레임 스타일)
  Widget _buildDxStepIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '진단 구분',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(dxLabels.length, (index) {
              final isSelected = index == _dxIndex;

              // 단계별 배경색과 테두리 색상
              Color color = isSelected
                  ? Colors.blueAccent
                  : Colors.grey.shade400;
              Color circleColor = isSelected ? Colors.blueAccent : Colors.white;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _dxIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // 점
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          ),
                          // 선
                          if (index < dxLabels.length - 1)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: Colors.grey.shade400,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dxLabels[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // 와이어프레임 스타일의 확장 가능한 슬라이더 입력 필드
  Widget _buildCollapsibleSliderInput({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required bool isExpanded,
    required VoidCallback onToggleExpand,
    String subLabel = '',
  }) {
    // 와이어프레임의 회색 배경 스타일 적용
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$label ($subLabel)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    isExpanded ? '-' : '+',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '점수: ${value.round()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '($min ~ $max)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: (max - min).toInt(),
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.grey.shade300,
                    onChanged: onChanged,
                  ),
                  // 와이어프레임처럼 하단에 범위 표시
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(min.round().toString()),
                      // 와이어프레임의 0, 0.5, 1, 2, 3 스타일을 참고하여 0.5 간격 레이블 구현
                      if (min.round() == 0 && max.round() == 3) ...[
                        const Text('0.5'),
                        const Text('1'),
                        const Text('2'),
                      ],
                      Text(max.round().toString()),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('이복순 님의 진료 기록'), // 와이어프레임 텍스트 반영
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 1. 진료 날짜 및 시간 ---
            _buildDateAndTimeSelector(),
            const Divider(height: 30),

            // --- 2. 메모 ---
            _buildMemoSection(),
            const Divider(height: 30),

            // --- 3. DX (진단 구분) ---
            _buildDxStepIndicator(),
            const Divider(height: 30),

            // --- 4. 인지 기능 평가 ---
            const Text(
              '인지 기능 평가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // MMSE
            _buildCollapsibleSliderInput(
              label: 'MMSE',
              subLabel: '간이정신상태검사',
              value: _mmseValue,
              min: 0,
              max: 30,
              onChanged: (newValue) => setState(() => _mmseValue = newValue),
              isExpanded: _isMmseExpanded,
              onToggleExpand: () =>
                  setState(() => _isMmseExpanded = !_isMmseExpanded),
            ),

            // MOCA
            _buildCollapsibleSliderInput(
              label: 'MoCA',
              subLabel: '몬트리얼 인지평가',
              value: _mocaValue,
              min: 0,
              max: 30,
              onChanged: (newValue) => setState(() => _mocaValue = newValue),
              isExpanded: _isMocaExpanded,
              onToggleExpand: () =>
                  setState(() => _isMocaExpanded = !_isMocaExpanded),
            ),

            // FAQ (와이어프레임 CDR 자리에 FAQ 구현)
            _buildCollapsibleSliderInput(
              label: 'FAQ',
              subLabel: '일상생활수행능력',
              value: _faqValue,
              min: 0,
              max: 30,
              onChanged: (newValue) => setState(() => _faqValue = newValue),
              isExpanded: _isFaqExpanded,
              onToggleExpand: () =>
                  setState(() => _isFaqExpanded = !_isFaqExpanded),
            ),

            // 기타 인지 기능 검사 (ADAS13, LDELTOTAL)
            _buildOtherCognitiveTestSection(),

            const Divider(height: 30),

            // --- 5. MRI 이미지 데이터 (와이어프레임 반영) ---
            _buildMriSection(),
            const Divider(height: 30),

            // --- 6. 환자 코멘트 (와이어프레임 반영) ---
            _buildPatientCommentSection(),

            const SizedBox(height: 80), // 하단 '추가' 버튼 공간 확보
          ],
        ),
      ),
      // --- Floating Action Button (FAB) for '추가' (와이어프레임 위치 참고) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              '추가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('진료 일자', style: TextStyle(fontSize: 16)),
        GestureDetector(
          onTap: () {
            // 현재 선택된 날짜와 시간을 하나의 DateTime 객체로 결합
            DateTime initialDateTime = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime.hour,
              _selectedTime.minute,
            );

            // ⭐️ flutter_datetime_picker를 사용하여 통합된 휠 피커 호출
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(2000, 1, 1),
              maxTime: DateTime(2101, 12, 31),
              // iOS 스타일 피커를 사용하도록 forceIosPicker: true 설정
              onChanged: (date) {
                // 값 변경 중에는 아무 작업도 하지 않음
              },
              onConfirm: (date) {
                // Confirm 시 상태 업데이트
                setState(() {
                  _selectedDate = date;
                  _selectedTime = TimeOfDay.fromDateTime(date);
                });
              },
              currentTime: initialDateTime,
              locale: LocaleType.ko, // 한국어 로케일 설정
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  // 와이어프레임과 동일한 날짜/시간 포맷
                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')} ${_selectedTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '메모',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            // 와이어프레임처럼 연필 아이콘
            const Icon(Icons.edit, size: 16, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        // 메모 텍스트 또는 편집 필드 (와이어프레임과 같이 "특이사항 없음"이 기본)
        _isMemoEditing
            ? TextFormField(
                controller: _memoController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: '진료 관련 특이사항을 기록하세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  isDense: true,
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    _isMemoEditing = false; // 편집 완료 시 모드 전환
                  });
                },
                // 포커스를 잃을 때도 저장되도록
                onTapOutside: (event) {
                  setState(() {
                    _isMemoEditing = false;
                  });
                },
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _isMemoEditing = true; // 텍스트 클릭 시 편집 모드 시작
                  });
                },
                child: Text(
                  _memoController.text.isEmpty
                      ? '특이사항 없음'
                      : _memoController.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: _memoController.text.isEmpty
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildMriSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MRI 이미지 데이터',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // 이미지 업로드 버튼 영역 (와이어프레임 스타일)
        InkWell(
          onTap: () {
            print('이미지 업로드 기능');
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.insert_drive_file_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  '이미지 업로드 (.jpg, .png, .jpeg)',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '환자 코멘트',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.edit,
              size: 16,
              color: Colors.grey,
            ), // 와이어프레임의 연필 아이콘
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _patientCommentController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '환자가 보고한 주관적 증상을 기록하세요.',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.all(12),
            isDense: true,
          ),
        ),
      ],
    );
  }

  // 나머지 인지 기능 검사 항목을 확장 가능한 형태로 추가
  Widget _buildOtherCognitiveTestSection() {
    return Column(
      children: [
        // ADAS13
        _buildCollapsibleSliderInput(
          label: 'ADAS13',
          subLabel: '치매 평가 척도 13항목',
          value: _adas13Value,
          min: 0,
          max: 85,
          onChanged: (newValue) => setState(() => _adas13Value = newValue),
          isExpanded: _isAdas13Expanded,
          onToggleExpand: () =>
              setState(() => _isAdas13Expanded = !_isAdas13Expanded),
        ),
        // LDELTOTAL
        _buildCollapsibleSliderInput(
          label: 'LDELTOTAL',
          subLabel: '논리적 기억 지연 회상 총점',
          value: _ldelTotalValue,
          min: 0,
          max: 25,
          onChanged: (newValue) => setState(() => _ldelTotalValue = newValue),
          isExpanded: _isLdelTotalExpanded,
          onToggleExpand: () =>
              setState(() => _isLdelTotalExpanded = !_isLdelTotalExpanded),
        ),
        // ABETA (생체 검사지만, 인지 기능 평가 아래에 와이어프레임 형태를 위해 배치)
        _buildBiomarkerInput(
          label: 'ABETA',
          hintText: 'Aβ42/40 비율 또는 농도 (실수)',
          controller: _abetaController,
        ),
        // PTAU
        _buildBiomarkerInput(
          label: 'PTAU',
          hintText: '인산화 타우 단백질 농도 (실수)',
          controller: _ptauController,
        ),
      ],
    );
  }

  // 생체 검사 데이터를 일반 TextFormField 형태로 만듦
  Widget _buildBiomarkerInput({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: InputBorder.none, // 배경색이 있으므로 테두리 제거
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  // --- Logic Methods ---

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitData() {
    final currentDx = dxLabels[_dxIndex];

    if (_dxIndex == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('DX (진단 구분)을 선택해 주세요.')));
      return;
    }

    // 최종 데이터를 콘솔에 출력
    print('--- 진료 기록 제출 ---');
    print(
      '진료 일시: ${_selectedDate.toIso8601String().split('T')[0]} ${_selectedTime.format(context)}',
    );
    print('DX: $currentDx');
    print('MMSE: ${_mmseValue.round()}');
    print('MoCA: ${_mocaValue.round()}');
    print('FAQ: ${_faqValue.round()}');
    print('LDELTOTAL: ${_ldelTotalValue.round()}');
    print('ADAS13: ${_adas13Value.round()}');
    print('ABETA: ${_abetaController.text}');
    print('PTAU: ${_ptauController.text}');
    print('메모: ${_memoController.text}');
    print('환자 코멘트: ${_patientCommentController.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$currentDx 진단, 진료 기록이 성공적으로 저장되었습니다.')),
    );
  }

  @override
  void dispose() {
    _abetaController.dispose();
    _ptauController.dispose();
    _memoController.dispose();
    _mriMemoController.dispose();
    _patientCommentController.dispose();
    super.dispose();
  }
}
