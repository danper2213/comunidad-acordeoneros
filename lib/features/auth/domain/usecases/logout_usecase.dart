import 'package:comunidad_acordeoneros/core/errors/failures.dart';
import 'package:comunidad_acordeoneros/core/utils/either.dart';
import 'package:comunidad_acordeoneros/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
