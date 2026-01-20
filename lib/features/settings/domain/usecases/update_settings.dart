import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

/// Use case for updating app settings
class UpdateSettings implements UseCase<Unit, Settings> {
  final SettingsRepository repository;

  UpdateSettings(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Settings settings) async {
    return await repository.saveSettings(settings);
  }
}
