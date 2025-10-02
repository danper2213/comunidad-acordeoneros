import 'package:comunidad_acordeoneros/core/errors/failures.dart';
import 'package:comunidad_acordeoneros/core/utils/either.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/entities/user_entity.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return await repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
