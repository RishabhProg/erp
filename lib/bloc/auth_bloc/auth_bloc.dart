import 'package:erp_app/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested); 
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await repository.login(event.username, event.password);

      final accessToken = response['access_token'];
      final sessionId = response['SessionId'];
      final xUserId = response['X-UserId'];
      final xToken = response['X_Token'];

      if (accessToken == null ||
          sessionId == null ||
          xUserId == null ||
          xToken == null ||
          accessToken is! String ||
          sessionId is! String ||
          xUserId is! String ||
          xToken is! String) {
        emit(const AuthFailure("Missing or invalid login response data."));
        return;
      }

      await secureStorage.write(key: 'accessToken', value: accessToken);
      await secureStorage.write(key: 'sessionId', value: sessionId);
      await secureStorage.write(key: 'xUserId', value: xUserId);
      await secureStorage.write(key: 'xToken', value: xToken);

      emit(
        AuthSuccess(
          accessToken: accessToken,
          sessionId: sessionId,
          xUserId: xUserId,
          xToken: xToken,
          userId: xUserId,
        ),
      );
    } catch (e) {
      emit(AuthFailure("Login failed: ${e.toString()}"));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final accessToken = await secureStorage.read(key: 'accessToken');
      final sessionId = await secureStorage.read(key: 'sessionId');
      final xUserId = await secureStorage.read(key: 'xUserId');
      final xToken = await secureStorage.read(key: 'xToken');

      if (accessToken != null &&
          sessionId != null &&
          xUserId != null &&
          xToken != null) {
        emit(AuthSuccess(
          accessToken: accessToken,
          sessionId: sessionId,
          xUserId: xUserId,
          xToken: xToken,
          userId: xUserId,
        ));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure("Failed to check auth status: ${e.toString()}"));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await secureStorage.deleteAll();
    emit(AuthInitial());
  }
}
