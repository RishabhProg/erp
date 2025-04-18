import 'package:erp_app/models/final_attendance_model.dart';
import 'package:erp_app/models/sem_model.dart';

class AttendanceState {
  final List<Semester> semesters;
  final List<AttendanceEntry> attendance;
  final bool isLoading;
  final int selectedSemesterId;

  AttendanceState({
    this.semesters = const [],
    this.attendance = const [],
    this.isLoading = false,
    this.selectedSemesterId = 1,
  });

  AttendanceState copyWith({
    List<Semester>? semesters,
    List<AttendanceEntry>? attendance,
    bool? isLoading,
    int? selectedSemesterId,
  }) {
    return AttendanceState(
      semesters: semesters ?? this.semesters,
      attendance: attendance ?? this.attendance,
      isLoading: isLoading ?? this.isLoading,
      selectedSemesterId: selectedSemesterId ?? this.selectedSemesterId,
    );
  }
}
