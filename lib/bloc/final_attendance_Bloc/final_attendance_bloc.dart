import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_event.dart';
import 'package:erp_app/bloc/final_attendance_Bloc/final_attendance_state.dart';
import 'package:erp_app/repository/final_attendance_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;

  AttendanceBloc(this.repository) : super(AttendanceState(isLoading: true)) {
    on<LoadSemestersAndAttendance>(_onLoadData);
    on<ChangeSemester>(_onChangeSemester);
  }

  Future<void> _onLoadData(
    LoadSemestersAndAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final semesters = await repository.fetchSemesters();
    final selected = semesters.first;
    final attendance = await repository.fetchAttendance(selected.userId);

    emit(state.copyWith(
      isLoading: false,
      semesters: semesters,
      selectedSemesterId: selected.id,
      attendance: attendance,
    ));
  }

  Future<void> _onChangeSemester(
    ChangeSemester event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final selected = state.semesters.firstWhere((s) => s.id == event.semesterId);
    final attendance = await repository.fetchAttendance(selected.userId);

    emit(state.copyWith(
      selectedSemesterId: event.semesterId,
      attendance: attendance,
      isLoading: false,
    ));
  }
}