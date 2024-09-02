import 'package:bloggo_app/models/user.dart';
import 'package:bloggo_app/repositories/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthCubit extends Cubit<AuthState> {
  final repository = AuthRepository();

  AuthCubit() : super(AuthState.initial());

  void login(String email, String password) async {
    emit(AuthState.loading());
    try {
      final response = await repository.login(email, password);
      if (response == null) {
        emit(AuthState.failure("User not found"));
        return;
      }
      emit(AuthState.success(response, true));
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  void logout() {
    emit(AuthState.initial());
  }
}

class AuthState {
  final AuthStatus status;
  final bool auth;
  final User? user;
  final String error;

  AuthState({
    required this.status,
    this.auth = false,
    this.user,
    this.error = '',
  });

  AuthState.initial()
      : this(status: AuthStatus.initial, error: '', auth: true, user: null);
  AuthState.loading() : this(status: AuthStatus.loading, error: '');
  AuthState.success(User user, bool auth)
      : this(status: AuthStatus.success, user: user, auth: auth, error: '');
  AuthState.failure(String error)
      : this(status: AuthStatus.failure, error: error, auth: false);
}
