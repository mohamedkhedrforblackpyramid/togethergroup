import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/end_points.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final response = await DioHelper.postData(
        url: EndPoints.login,
        data: {
          'email': event.email,
          'password': event.password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        emit(AuthSuccess(
          token: token,
          message: 'Login successful',
        ));
      } else {
        emit(const AuthError(message: 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      if (event.password != event.confirmPassword) {
        emit(const AuthError(message: 'Passwords do not match'));
        return;
      }

      emit(AuthLoading());

      final response = await DioHelper.postData(
        url: EndPoints.register,
        data: {
          'name': event.name,
          'email': event.email,
          'password': event.password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        emit(AuthSuccess(
          token: token,
          message: 'Registration successful',
        ));
      } else {
        emit(const AuthError(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final response = await DioHelper.postData(
        url: EndPoints.logout,
        data: {},
      );

      if (response.statusCode == 200) {
        emit(const AuthSuccess(
          token: '',
          message: 'Logout successful',
        ));
      } else {
        emit(const AuthError(message: 'Logout failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
} 