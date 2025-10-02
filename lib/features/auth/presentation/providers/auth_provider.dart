import 'package:flutter/material.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/entities/user_entity.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/login_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/signup_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/logout_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/google_signin_usecase.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.googleSignInUseCase,
  });

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Sign in with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;

    final result = await loginUseCase(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (user) {
        _user = user;
        _setStatus(AuthStatus.authenticated);
        return true;
      },
    );
  }

  /// Sign up with email and password
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;

    final result = await signUpUseCase(
      email: email,
      password: password,
      displayName: displayName,
    );

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (user) {
        _user = user;
        _setStatus(AuthStatus.authenticated);
        return true;
      },
    );
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;

    final result = await googleSignInUseCase();

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (user) {
        _user = user;
        _setStatus(AuthStatus.authenticated);
        return true;
      },
    );
  }

  /// Sign out
  Future<bool> signOut() async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;

    final result = await logoutUseCase();

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (_) {
        _user = null;
        _setStatus(AuthStatus.unauthenticated);
        return true;
      },
    );
  }

  /// Check current user
  Future<void> checkCurrentUser() async {
    _setStatus(AuthStatus.loading);

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) {
        _user = null;
        _setStatus(AuthStatus.unauthenticated);
      },
      (user) {
        if (user != null) {
          _user = user;
          _setStatus(AuthStatus.authenticated);
        } else {
          _user = null;
          _setStatus(AuthStatus.unauthenticated);
        }
      },
    );
  }
}
