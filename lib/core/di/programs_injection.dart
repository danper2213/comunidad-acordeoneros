import 'package:comunidad_acordeoneros/features/programs/data/datasources/programs_local_datasource.dart';
import 'package:comunidad_acordeoneros/features/programs/data/datasources/comments_datasource.dart';
import 'package:comunidad_acordeoneros/features/programs/data/repositories/programs_repository_impl.dart';
import 'package:comunidad_acordeoneros/features/programs/presentation/providers/programs_provider.dart';

class ProgramsInjection {
  static late ProgramsProvider programsProvider;

  static Future<void> init() async {
    // Data sources
    final programsLocalDataSource = ProgramsLocalDataSourceImpl();
    final commentsDataSource = CommentsDataSourceImpl();

    // Repository
    final programsRepository = ProgramsRepositoryImpl(
      localDataSource: programsLocalDataSource,
      commentsDataSource: commentsDataSource,
    );

    // Provider
    programsProvider = ProgramsProvider(
      repository: programsRepository,
    );
  }
}
