import 'package:comunidad_acordeoneros/core/errors/failures.dart';
import 'package:comunidad_acordeoneros/core/utils/either.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/entities/user_entity.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
