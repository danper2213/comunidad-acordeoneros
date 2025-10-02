import 'package:comunidad_acordeoneros/core/errors/failures.dart';
import 'package:comunidad_acordeoneros/core/utils/either.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/entities/user_entity.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}
