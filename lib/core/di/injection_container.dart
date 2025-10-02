import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:comunidad_acordeoneros/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:comunidad_acordeoneros/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/login_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/signup_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/logout_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:comunidad_acordeoneros/features/auth/presentation/providers/auth_provider.dart';

class InjectionContainer {
  static late AuthProvider authProvider;

  static Future<void> init() async {
    // External
    final firebaseAuth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();

    // Data sources
    final authRemoteDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );

    // Repositories
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
    );

    // Use cases
    final loginUseCase = LoginUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    final googleSignInUseCase = GoogleSignInUseCase(authRepository);

    // Providers
    authProvider = AuthProvider(
      loginUseCase: loginUseCase,
      signUpUseCase: signUpUseCase,
      logoutUseCase: logoutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      googleSignInUseCase: googleSignInUseCase,
    );
  }
}
